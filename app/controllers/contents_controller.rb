class ContentsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def add_content
    @content = Content.new
  end

  def create_content
    @lesson = Lesson.find_by(id: params[:lesson_id])
    authorize @lesson, :create_lesson?, policy_class: LessonPolicy
    @content = @lesson.contents.build(content_params)
    if @content.content_type != "text" && params[:files].present?
      error = acceptable_file(params[:files], @content)
      if error.size ==0 && @content.files.attach(params[:files])
        @content.description = 'Saved in file'
      else
        flash[:message] = error[:files]
        redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
        return
      end
    end
    if @content.save
      flash[:notice] = "A new content is added"
      redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
    else
      flash[:notice] = "Please try again"
      redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
    end
  end

  def destroy_content
    @content = Content.find_by(id: params[:content_id])
    authorize @content if @content.present?
    if @content.present? && @content.destroy
      flash[:notice] = "This content has been deleted"
    else
      flash[:notice] = "Please try again!"
    end
    redirect_to "/dashboard/show_a_course/#{@content.lesson.course_id}"
  end

  private

  def content_params
    params.require(:content).permit(:title, :description, :content_type)
  end

  def acceptable_file(files, record)
    acceptable_image = ["image/jpeg", "image/png", "image/jpg"]
    acceptable_pdf = ["application/pdf"]
    acceptable_video = ["video/mp4", "video/mpeg"]
    unless (record.content_type == "pdf" && acceptable_pdf.include?(files.content_type))  ||
      (record.content_type == "image" && acceptable_image.include?(files.content_type)) ||
      (record.content_type == "video" && acceptable_video.include?(files.content_type))
      record.errors.add(:files, "Does not match file format")
    end
    record.errors
  end
end

