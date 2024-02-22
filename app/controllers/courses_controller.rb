class CoursesController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def new_course
    @page_title = I18n.t('controller.courses.new_course.add_new_course')
    @course = Course.new
    authorize @course
  end

  def create_course
    @user = current_user
    @course = @user.courses.new(course_params)
    authorize @course if @course.present?
    @enrollment = @course.enrollments.build(user: @user, enrollment_type: USER_TYPE_INSTRUCTOR)
    if @course.save && @enrollment.save
      flash[:notice] = I18n.t('controller.courses.create_course.course_added')
      redirect_to dashboard_show_course_path
    else
      render :new_course, status: :unprocessable_entity
    end
  end

  def show_course
    @page_title = I18n.t('controller.courses.show_course.show_courses')
    @courses = policy_scope(Course)
    authorize @courses
  end

  def show_single_course
    @page_title = I18n.t('controller.courses.show_single_course.show_course')
    @course = Course.includes(:lessons).find_by(id: params[:id])
    return invalid_params unless @course.present?

    authorize @course if @course.present?
    @lesson = Lesson.new
    @content = Content.new
  end

  def edit_course
    @page_title = I18n.t('controller.courses.edit_course.edit_a_course')
    @course = Course.find_by(id: params[:id])
    return invalid_params unless @course.present?

    authorize @course
  end

  def save_course
    @course = Course.find_by(id: params[:id])
    return invalid_params unless @course.present?

    authorize @course if @course.present?
    if @course.update(course_params)
      flash[:notice] = I18n.t('controller.courses.save_course.success_notice')
      redirect_to dashboard_show_course_path
    else
      render :new_course, status: :unprocessable_entity
    end
  end

  def destroy_course
    @course = Course.find_by(id: params[:id])
    return invalid_params unless @course.present?

    authorize @course if @course.present?
    instructor = Enrollment.find_by(course_id: @course.id, enrollment_type: USER_TYPE_INSTRUCTOR)
    if @course.destroy
      UserMailer.send_mail_for_delete_course(instructor.user, @course).deliver_now
      flash[:notice] = I18n.t('controller.courses.delete_course.success_notice')
      redirect_to dashboard_show_course_path
    else
      flash[:notice] = I18n.t('errors.messages.try_again')
      redirect_to dashboard_show_course_path
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :description)
  end
end
