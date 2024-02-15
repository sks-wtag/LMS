class EnrollmentsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    @page_title = I18n.t('controller.enrollments.index.title')
    @course = Course.find_by(id: params[:course_id])
    unless @course.present?
      invalid_params
      return
    end
    authorize @course if @course.present?
    @users = policy_scope(User)
  end

  def enroll
    @course = Course.find_by(id: params[:course_id])
    authorize @course, :index? if @course.present?
    @user = User.find_by(id: params[:user_id])
    unless @course.present? && @user.present?
      invalid_params
      return
    end
    @enrollment = Enrollment.find_by(user_id: @user.id, course_id: @course.id)
    if @enrollment.present?
      flash[:notice] = I18n.t('controller.enrollments.enroll.enrolled_notice')
      redirect_to "/dashboard/enroll_course/#{params[:course_id]}"
      return
    end

    @enrollment = Enrollment.new(
      completion_time: params[:completion_time],
      user_id: @user.id,
      course_id: @course.id,
      enrollment_type: 'learner')
    if !@user.admin? && @enrollment.present? && @enrollment.save
      SendScheduleMail.perform_at(@enrollment.completion_time - 2.days, @enrollment.id)
      flash[:notice] = I18n.t('controller.enrollments.enroll.enroll_success_notice')
    elsif @enrollment.errors[:completion_time].present?
      flash[:error] = @enrollment.errors[:completion_time]
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
    end
    redirect_to "/dashboard/enroll_course/#{params[:course_id]}"
  end

  def dis_enroll
    @course = Course.find_by(id: params[:course_id])
    authorize @course, :index? if @course.present?
    @user = User.find_by(id: params[:user_id])
    unless @course.present? || @user.present?
      invalid_params
      return
    end
    @enrollment = Enrollment.find_by(user_id: @user.id, course_id: @course.id)
    unless @enrollment.present?
      flash[:notice] = I18n.t('controller.enrollments.dis_enroll.already_dis_enroll_notice')
      redirect_to "/dashboard/enroll_course/#{params[:course_id]}"
      return
    end
    total_lesson = Lesson.where(course_id: @course.id).count
    complete_lesson = UserCourseProgress.where(user_id: @user.id, enrollment_id: @enrollment.id).count
    if @enrollment.enrollment_type == 'instructor'
      flash[:message] = I18n.t('controller.enrollments.dis_enroll.owner_notice')
    elsif total_lesson == complete_lesson && total_lesson != 0
      flash[:message] = I18n.t('controller.enrollments.dis_enroll.completed_notice')
    elsif @enrollment.present? && @enrollment.destroy
      flash[:notice] = I18n.t('controller.enrollments.dis_enroll.success_notice')
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
    end
    redirect_to "/dashboard/enroll_course/#{params[:course_id]}"
  end

  def assign_all_user
    @course = Course.find_by(id: params[:course_id])
    unless @course.present?
      invalid_params
      return
    end
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
    redirect_to "/dashboard/enroll_course/#{@course.id}"
  end

  def unassign_all_user
    @course = Course.find_by(id: params[:course_id])
    unless @course.present?
      invalid_params
      return
    end
    authorize @course, :index? if @course.present?
    Enrollment.where(course_id: @course.id, enrollment_type: 'learner').destroy_all
    flash[:notice] = I18n.t('controller.enrollments.dispose_all_user.success_notice')
    redirect_to "/dashboard/enroll_course/#{@course.id}"
  end

  def complete_lesson
    @lesson = Lesson.find_by(id: params[:lesson_id])
    @enrollment = Enrollment.find_by(id: params[:enrollment_id])
    unless @lesson.present? && @enrollment.present?
      invalid_params
      return
    end
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
end
