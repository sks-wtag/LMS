class EnrollmentsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!
  before_action :search_and_assign_from_params_info
  before_action :redirect_if_have_invalid_params, only: [:index, :assign_all_user, :unassign_all_user]

  def index
    @page_title = I18n.t('controller.enrollments.index.title')
    authorize @course if @course.present?
    @users = policy_scope(User)
  end

  def enroll
    return invalid_params unless @user.present? && @course.present?

    authorize @course, :index? if @course.present?
    authorize @user ,:enroll?, policy_class: CoursePolicy
    @enrollment = Enrollment.find_by(user_id: @user.id, course_id: @course.id)
    if @enrollment.present?
      flash[:notice] = I18n.t('controller.enrollments.enroll.enrolled_notice')
      redirect_to_enroll_course(params[:course_id])
      return
    end

    params[:completion_time ] = DateTime.now unless params[:completion_time].present?
    @enrollment = Enrollment.new(
      completion_time: params[:completion_time],
      user_id: @user.id,
      course_id: @course.id,
      enrollment_type: USER_TYPE_LEARNER)
    if @enrollment.present? && @enrollment.save
      SendScheduleMail.perform_at(@enrollment.completion_time - 2.days, @enrollment.id)
      flash[:notice] = I18n.t('controller.enrollments.enroll.enroll_success_notice')
    elsif @enrollment.errors[:completion_time].present?
      flash[:error] = @enrollment.errors[:completion_time]
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
    end
    redirect_to_enroll_course(params[:course_id])
  end

  def dis_enroll
    return invalid_params unless @course.present? && @user.present?

    authorize @course, :index? if @course.present?
    @enrollment = Enrollment.find_by(user_id: @user.id, course_id: @course.id)
    unless @enrollment.present?
      flash[:notice] = I18n.t('controller.enrollments.dis_enroll.already_dis_enroll_notice')
      redirect_to_enroll_course(params[:course_id])
      return
    end

    total_lesson = Lesson.where(course_id: @course.id).count
    complete_lesson = UserCourseProgress.where(user_id: @user.id, enrollment_id: @enrollment.id).count
    if @enrollment.enrollment_type == USER_TYPE_INSTRUCTOR
      flash[:message] = I18n.t('controller.enrollments.dis_enroll.owner_notice')
    elsif total_lesson == complete_lesson && total_lesson != 0
      flash[:message] = I18n.t('controller.enrollments.dis_enroll.completed_notice')
    elsif @enrollment.present? && @enrollment.destroy
      flash[:notice] = I18n.t('controller.enrollments.dis_enroll.success_notice')
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
    end
    redirect_to_enroll_course(params[:course_id])
  end

  def assign_all_user
    authorize @course, :index? if @course.present?
    if !params[:completion_time].present? || params[:completion_time] <= DateTime.now + 3.days
      flash[:notice] = I18n.t('activerecord.enrollment.completion_time')
    else
      is_job_running = { value: true }
      EnrollmentCreationJob.perform_now(
        current_user.organization_id,
        @course.id,
        params[:completion_time],
        is_job_running)
      if is_job_running[:value]
        flash[:notice] = I18n.t('controller.enrollments.assign_all_user.processing_notice')
      else
        flash[:notice] = I18n.t('controller.enrollments.enroll.enroll_success_notice')
      end
    end
    redirect_to_enroll_course(@course.id)
  end

  def unassign_all_user
    authorize @course, :index? if @course.present?
    Enrollment.where(course_id: @course.id, enrollment_type: USER_TYPE_LEARNER).destroy_all
    flash[:notice] = I18n.t('controller.enrollments.dispose_all_user.success_notice')
    redirect_to_enroll_course(@course.id)
  end

  def complete_lesson
    return invalid_params unless @lesson.present? && @enrollment.present?

    authorize @lesson, :complete_lesson?
    @course_progress = UserCourseProgress.new(
      user_id: current_user.id,
      lesson_id: @lesson.id,
      enrollment_id: @enrollment.id,
      complete_status: true,
      complete_time: DateTime.now
    )
    if @course_progress.save
      flash[:notice] = I18n.t('controller.enrollments.complete_lesson.success_notice')
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
    end
    redirect_to "/dashboard/show_a_course/#{@enrollment.course_id}"
  end

  private

  def search_and_assign_from_params_info
    @course = Course.find_by(id: params[:course_id]) if params[:course_id].present?
    @user = User.find_by(id: params[:user_id]) if params[:user_id].present?
    @lesson = Lesson.find_by(id: params[:lesson_id]) if params[:lesson_id].present?
    @enrollment = Enrollment.find_by(id: params[:enrollment_id]) if params[:enrollment_id].present?
  end

  def redirect_to_enroll_course(course_id)
    redirect_to "/dashboard/enroll_course/#{course_id}"
  end

  def redirect_if_have_invalid_params
    invalid_params unless @course.present?
  end
end
