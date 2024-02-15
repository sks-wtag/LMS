require 'rails_helper'

RSpec.describe "Lessons", type: :request do
  let!(:organization) { create(:organization)}
  let!(:admin) { create(:user, organization:organization, role: "admin") }
  let!(:instructor) { create(:user, organization:organization, role: "instructor") }
  let!(:learner) { create(:user, organization:organization, role: "learner") }
  let!(:course) { create(:course) }
  let!(:enrollment) { create(:enrollment, enrollment_type: "instructor", user_id: instructor.id, course_id: course.id) }
  let!(:lesson) { create(:lesson, course_id: course.id) }
  let!(:invalid_lesson) { create(:lesson, course_id: course.id)}
  describe "POST /dashboard/add_lesson/:course_id" do
    it "when it created with valid params as an instructor" do
      login(instructor)
      expect do
        post "/dashboard/add_lesson/#{course.id}", params: { lesson: lesson }, as: :json
      end.to change(Lesson, :count).by(1)
      expect(flash[:notice]).to eq('A new lesson is added')
      expect(response).to have_http_status(302)
    end

    it "when it created with invalid params as an instructor" do
      login(instructor)
      invalid_lesson.title = ''
      invalid_lesson.description = ''
      invalid_lesson.score = 0
      invalid_lesson.valid?
      post "/dashboard/add_lesson/#{course.id}", params: { lesson: { title: '', description: '' } }, as: :json
      expect(flash[:error]).to eq(invalid_lesson.errors.full_messages.join(", "))
      expect(response).to have_http_status(302)
    end

    it "when it created with valid params as an learner" do
      login(learner)
      post "/dashboard/add_lesson/#{course.id}", params: { lesson: lesson }, as: :json
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end

    it "when it created with valid params as an admin" do
      login(admin)
      post "/dashboard/add_lesson/#{course.id}", params: { lesson: lesson }, as: :json
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe "GET /dashboard/edit_lesson/:lesson_id" do
    it 'when it created a valid request as an instructor' do
      login(instructor)
      get "/dashboard/edit_lesson/#{lesson.id}"
      expect(assigns(:page_title)).to eq('Dashboard -> Edit a lesson')
      expect(response).to render_template(:edit_lesson)
    end

    it 'when it created a valid request as an learner' do
      login(learner)
      get "/dashboard/edit_lesson/#{lesson.id}"
      expect(assigns(:page_title)).to eq('Dashboard -> Edit a lesson')
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end

    it 'when it created a valid request as an admin' do
      login(admin)
      get "/dashboard/edit_lesson/#{lesson.id}"
      expect(assigns(:page_title)).to eq('Dashboard -> Edit a lesson')
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end

  end

  describe "PATCH /dashboard/edit_lesson/:lesson_id" do
    it "when it created a valid request as an instructor" do
      login(instructor)
      expect do
        patch "/dashboard/edit_lesson/#{lesson.id}", params: { lesson: lesson }, as: :json
      end.to change(Lesson, :count).by(0)
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq("This lesson is updated")
    end

    it "when it created a valid request as a learner" do
      login(learner)
      patch "/dashboard/edit_lesson/#{lesson.id}", params: { lesson: lesson }, as: :json
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end

    it "when it created a valid request as an admin" do
      login(admin)
      patch "/dashboard/edit_lesson/#{lesson.id}", params: { lesson: lesson }, as: :json
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  describe "DELETE /dashboard/delete_lesson/:lesson_id" do
    it "when it crated a valid request as an admin" do
      login(admin)
      expect do
        delete "/dashboard/delete_lesson/#{lesson.id}"
      end.to change(Lesson, :count).by(-1)
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq("This lesson is deleted")
    end
    it "when it crated a valid request as an instructor" do
      login(instructor)
      expect do
        delete "/dashboard/delete_lesson/#{lesson.id}"
      end.to change(Lesson, :count).by(-1)
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq("This lesson is deleted")
    end
    it "when it crated a valid request as an learner" do
      login(learner)
      expect do
        delete "/dashboard/delete_lesson/#{lesson.id}"
      end.to change(Lesson, :count).by(0)
      expect(response).to have_http_status(302)
      expect(flash[:alert]).to eq('You are not authorized to perform this action.')
    end
  end

  def login(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end
end
