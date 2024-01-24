class ContentsController < ApplicationController
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  layout 'dashboard'
  before_action :authenticate_user!

  def add_content
    @content = Content.new({})
  end

  def create_content
    @lesson = Lesson.find_by(id: params[:lesson_id])
    if params[:files].present?
      uploaded_file = params[:files]
      file_path = Rails.root.join('public', 'uploads', DateTime.now.to_s )
      File.open(Rails.root.join('public','uploads' ,file_path), 'wb') do |file|
        file.write(uploaded_file.read)
      end
    end
    @content = @lesson.contents.build(content_params)
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
