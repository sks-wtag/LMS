require 'rails_helper'

RSpec.describe "Contents", type: :request do
  let!(:admin) { create(:user, role: "admin") }
  let!(:instructor) { create(:user, role: "instructor") }
  let!(:learner) { create(:user, role: "learner") }
  let!(:course) { create(:course) }
  let!(:enrollment) { create(:enrollment, enrollment_type: "instructor", user_id: instructor.id, course_id: course.id) }
  let!(:lesson) { create(:lesson, course_id: course.id) }
  let!(:content) { create(:content, lesson_id: lesson.id) }

  describe "GET /dashboard/save_content" do
    it "when it created a valid request as an instructor" do
      login(instructor)
      post "/dashboard/save_content/#{lesson.id}", params: { content: content }, as: :json
      expect(flash[:notice]).to eq("A new content is added")
    end

    it "when it created a valid request as an admin with file" do
      login(instructor)
      file_path = Rails.root.join('spec', 'fixtures', 'images.jpg')
      content.content_type = "image"
      post "/dashboard/save_content/#{lesson.id}",
           params:
             {
               content:
                 {
                   title: content.title,
                   description: content.description,
                   content_type: "image"
                 },
               files: fixture_file_upload(file_path, 'image/jpg')
             }
      expect(flash[:notice]).to eq("A new content is added")
    end

    it "when it created a valid request as an learner" do
      login(learner)
      post "/dashboard/save_content/#{lesson.id}", params: { content: content }, as: :json
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end


  describe "DELETE /dashboard/delete_content/:content_id" do
    it "when it created a valid request as an instructor" do
      login(instructor)
      delete "/dashboard/delete_content/#{content.id}"
      expect(flash[:notice]).to eq("This content has been deleted")
    end

    it "when it created a valid request as an admin" do
      login(admin)
      delete "/dashboard/delete_content/#{content.id}"
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end

  def login(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end
end
