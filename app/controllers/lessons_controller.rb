class LessonsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout 'dashboard'
  before_action :authenticate_user!

  def create_lesson
    @course = Course.find_by(id: params[:course_id])
    @lesson = @course.lessons.build(lesson_params)
    if @lesson.save
      flash[:notice] = 'A new lesson is added'
      redirect_to "/dashboard/show_a_course/#{@course.id}"
    else
      flash[:notice] = "Please try again!"
      redirect_to "/dashboard/show_a_course/#{@course.id}"
    end
  end

  def destroy_lesson
    @lesson = Lesson.find_by(id: params[:lesson_id])
    course_id = @lesson.course_id
    if @lesson.destroy
      flash[:notice] = "This lesson is deleted"
      redirect_to "/dashboard/show_a_course/#{course_id}"
    else
      flash[:notice] = "Please try again"
      redirect_to "/dashboard/show_a_course/#{course_id}"
    end
  end

  def edit_lesson
    @page_title = 'Dashboard -> Edit a lesson'
    @lesson = Lesson.find_by(id: params[:lesson_id])
  end

  def save_lesson
    @lesson = Lesson.find_by(id: params[:lesson_id])
    if @lesson.update(lesson_params)
      flash[:notice] = "This lesson is updated"
      redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
    else
      flash[:notice] = "Please try again"
      redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
    end
  end

  def show_lesson
    @course = Course.includes(:lessons).find_by(id: params[:course_id])
  end

  private

  def user_not_authorized
    flash[:notice] = 'You are not authorized to perform this action.'
    redirect_to dashboard_show_user_path
  end

  def lesson_params
    params.require(:lesson).permit(:title, :description)
  end
end
