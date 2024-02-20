class ContentsController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!

  def add_content
    @content = Content.new
  end

  def create_content
    @lesson = Lesson.find_by(id: params[:lesson_id])
    return invalid_params unless  @lesson.present?
    authorize @lesson, :create_lesson?, policy_class: LessonPolicy
    @content = @lesson.contents.build(content_params)
    if @content.content_type != 'text' && params[:files].present?
      error = acceptable_file(params[:files], @content)
      if error.size == 0 && @content.files.attach(params[:files])
        @content.description = I18n.t('controller.content.create_content.description')
      else
        flash[:message] = error[:files]
        redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
        return
      end
    end
    if @content.save
      flash[:notice] = I18n.t('controller.content.create_content.content_added')
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
    end
    redirect_to "/dashboard/show_a_course/#{@lesson.course_id}"
  end

  def destroy_content
    @content = Content.find_by(id: params[:content_id])
    return invalid_params unless @content.present?
    authorize @content
    if @content.present? && @content.destroy
      flash[:notice] = I18n.t('controller.content.destroy_content.content_deleted')
    else
      flash[:alert] = I18n.t('errors.messages.try_again')
    end
    redirect_to "/dashboard/show_a_course/#{@content.lesson.course_id}"
  end

  private

  def content_params
    params.require(:content).permit(:title, :description, :content_type)
  end

  def acceptable_file(files, record)
    acceptable_image = I18n.t('controller.content.create_content.image_formats')
    acceptable_pdf = I18n.t('controller.content.create_content.pdf_formats')
    acceptable_video = I18n.t('controller.content.create_content.video_formats')
    unless (record.content_type == 'pdf' && acceptable_pdf.include?(files.content_type))  ||
      (record.content_type == 'image' && acceptable_image.include?(files.content_type)) ||
      (record.content_type == 'video' && acceptable_video.include?(files.content_type))
      record.errors.add(:files, I18n.t('errors.messages.does_not_match_file_format'))
    end
    record.errors
  end
end
