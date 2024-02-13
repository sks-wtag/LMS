class LessonsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def create_lesson
    @course = Course.find_by(id: params[:course_id])
    unless @course.present?
      invalid_params(dashboard_show_course_path)
      return
    end
    @lesson = @course.lessons.build(lesson_params)
    authorize @lesson, policy_class: LessonPolicy
    if @lesson.save
      flash[:notice] = I18n.t('controller.lessons.create_lesson.success_notice')
      redirect_to "/dashboard/show_a_course/#{@course.id}"
    else
      if @lesson.errors.any?
        flash[:error] = @lesson.errors.full_messages.join(", ")
      else
        flash[:alert] = I18n.t('errors.messages.try_again')
      end
      redirect_to "/dashboard/show_a_course/#{@course.id}"
    end
  end

  def destroy_lesson
    @lesson = Lesson.find_by(id: params[:lesson_id])
    unless @lesson.present?
      invalid_params(dashboard_show_course_path)
      return
    end
    authorize @lesson
    course_id = @lesson.course_id
    if @lesson.present? && @lesson.destroy
      flash[:notice] = I18n.t('controller.lessons.destroy_lesson.success_notice')
      redirect_to "/dashboard/show_a_course/#{course_id}"
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
      redirect_to "/dashboard/show_a_course/#{course_id}"
    end
  end

  def edit_lesson
    @page_title = I18n.t('controller.lessons.edit_lesson.title')
    @lesson = Lesson.find_by(id: params[:lesson_id])
    unless @lesson.present?
      invalid_params(dashboard_show_course_path)
      return
    end
    authorize @lesson
  end

  def save_lesson
    @lesson = Lesson.find_by(id: params[:lesson_id])
    unless @lesson.present?
      invalid_params(dashboard_show_course_path)
      return
    end
    authorize @lesson, :edit_lesson?
    if @lesson.update(lesson_params)
      flash[:notice] = I18n.t('controller.lessons.save_lesson.success_notice')
      redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
    elsif  @lesson.errors.any?
      render :edit_lesson, status: :unprocessable_entity
    else
      flash[:notice] = I18n.t('errors.messages.try_again')
      redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
    end
  end

  def show_lesson
    @course = Course.includes(:lessons).find_by(id: params[:course_id])
    authorize @course, :show_course?, policy_class: CoursePolicy
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :description, :score)
  end

  def invalid_params(redirect_path)
    flash[:error] = I18n.t('errors.messages.invalid_params')
    redirect_to redirect_path
  end
end
