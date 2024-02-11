class EnrollmentsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def index
    @page_title = 'Dashboard -> Enrollment'
    @course = Course.find_by(id: params[:course_id])
    authorize @course if @course.present?
    unless @course.present?
      flash[:notice] = "Invalid params"
      redirect_to dashboard_show_course_path
      return
    end
    @users = policy_scope(User)
  end

  def enroll
    @course = Course.find_by(id: params[:course_id])
    authorize @course, :index? if @course.present?
    @user = User.find_by(id: params[:user_id])
    unless @course.present? || @user.present?
      flash[:notice] = "Invalid params"
      redirect_to dashboard_show_course_path
      return
    end
    @enrollment = Enrollment.find_by(user_id: @user.id, course_id: @course.id)
    if @enrollment.present?
      flash[:notice] = "This course has already been enrolled"
      redirect_to "/dashboard/enroll_course/#{params[:course_id]}"
      return
    end

    @enrollment = Enrollment.new(
      completion_time: params[:completion_time],
      user_id: @user.id,
      course_id: @course.id,
      enrollment_type: 'learner')
    if @enrollment.present? && @enrollment.save
      flash[:notice] = "Enrolled successfully"
    elsif @enrollment.errors[:completion_time].present?
      flash[:notice] = @enrollment.errors[:completion_time]
    else
      flash[:notice] = "Please try again!"
    end
    redirect_to "/dashboard/enroll_course/#{params[:course_id]}"
  end

  def dis_enroll
    @course = Course.find_by(id: params[:course_id])
    authorize @course, :index? if @course.present?
    @user = User.find_by(id: params[:user_id])
    unless @course.present? || @user.present?
      flash[:notice] = "Invalid params"
      redirect_to dashboard_show_course_path
      return
    end
    @enrollment = Enrollment.find_by(user_id: @user.id, course_id: @course.id)
    unless @enrollment.present?
      flash[:notice] = "This course has not already been enrolled in by this user."
      redirect_to "/dashboard/enroll_course/#{params[:course_id]}"
      return
    end
    total_lesson = Lesson.where(course_id: @course.id).count
    complete_lesson = UserCourseProgress.where(user_id: @user.id, enrollment_id: @enrollment.id).count
    if @enrollment.enrollment_type == "instructor"
      flash[:notice] = "He/She is the owner of this course."
    elsif total_lesson == complete_lesson && total_lesson != 0
      flash[:notice] = "This course has already been completed."
    elsif @enrollment.present? && @enrollment.destroy
      flash[:notice] = "Successfully dis-enroll."
    else
      flash[:notice] = "Please try again!"
    end
    redirect_to "/dashboard/enroll_course/#{params[:course_id]}"
  end

  def complete_lesson
    @lesson = Lesson.find_by(id: params[:lesson_id])
    authorize @lesson, :complete_lesson? if @lesson.present?
    @enrollment = Enrollment.find_by(id: params[:enrollment_id])
    unless @lesson.present? || @enrollment.present?
      flash[:notice] = "Invalid request!"
      redirect_to dashboard_show_course_path
      return
    end
    @course_progress = UserCourseProgress.new(
      user_id: current_user.id,
      lesson_id: @lesson.id,
      enrollment_id: @enrollment.id,
      complete_status: true,
      complete_time: DateTime.now
    )
    if @course_progress.save
      flash[:notice] = "Thanks for completing this lesson!"
    else
      flash[:notice] = "Please try again!"
    end
    redirect_to "/dashboard/show_a_course/#{@enrollment.course_id}"
  end
end
