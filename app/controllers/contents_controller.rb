class ContentsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def add_content
    @content = Content.new({})
  end

  def create_content
    @lesson = Lesson.find_by(id: params[:lesson_id])
    authorize @lesson, :create_lesson? , policy_class: LessonPolicy
    @content = @lesson.contents.build(content_params)
    if params[:files].present?
      @content.files.attach(params[:files])
      @content.description = 'Saved in file'
    end
    if @content.save
      flash[:notice] = "A new content is added"
      redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
    else
      flash[:notice] = "Please try again"
      redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
    end
  end

  private
  def content_params
    params.require(:content).permit(:title, :description, :content_type)
  end
end
