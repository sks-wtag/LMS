class CoursesController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout 'dashboard'
  before_action :authenticate_user!

  def new_course
    @page_title = 'Dashboard -> Add a course'
    @course = Course.new({})
  end

  def create_course
    @course = Course.new(course_params)
    if @course.save
      flash[:notice] = 'This course has been added'
      redirect_to dashboard_show_course_path
    else
      render :new_course, status: :unprocessable_entity
    end
  end

  def show_course
    @page_title = 'Dashboard -> Show courses'
    @courses = Course.all
  end

  def show_single_course
    @page_title = 'Dashboard -> Show a courses'
    @course = Course.includes(:lessons).find_by(id: params[:id])
    @lesson = Lesson.new({})
  end

  def edit_course
    @page_title = 'Dashboard -> Edit a course'
    @course = Course.find_by(id: params[:id])
  end

  def save_course
    @course = Course.find_by(id: params[:id])
    if @course.update(course_params)
      flash[:notice] = 'Successfully updated'
      redirect_to dashboard_show_course_path
    else
      render :new_course, status: :unprocessable_entity
    end
  end

  def destroy_course
    @course = Course.find_by(id: params[:id])
    if @course.destroy
      flash[:notice] = "This course is deleted successfully"
      redirect_to dashboard_show_course_path
    else
      flash[:notice] = "Please try again!"
      redirect_to dashboard_show_course_path
    end
  end
  private

  def course_params
    params.require(:course).permit(:title, :description)
  end
end
