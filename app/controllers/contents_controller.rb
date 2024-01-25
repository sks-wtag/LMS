class ContentsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout 'dashboard'
  before_action :authenticate_user!

  def add_content
    @content = Content.new({})
  end

  def create_content
    @lesson = Lesson.find_by(id: params[:lesson_id])
    @content = @lesson.contents.build(content_params)
    if params[:files].present?
      @content.description = store_uploaded_file
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

  def store_uploaded_file
    uploaded_file = params[:files]
    filename = Rails.root.join(
      'public',
      'uploads',
      "#{Time.now.to_i}_#{uploaded_file.original_filename || uploaded_file.original_filename.force_encoding('UTF-8')}")
    File.open(filename, 'wb') do |file|
      file.write(uploaded_file.read)
    end
    filename
  end
end
