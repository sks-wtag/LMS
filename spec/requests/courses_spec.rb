require 'rails_helper'

RSpec.describe "Courses", type: :request do
  let!(:admin) { create(:user, role: 'admin') }
  let!(:instructor) { create(:user, role: 'instructor') }
  let!(:learner) { create(:user, role: 'learner') }
  let!(:course1) { create(:course) }
  let!(:enrollment) { create(:enrollment, user_id: admin.id, course_id: course1.id) }
  describe 'GET /dashboard/add_course' do
    it 'when it created a valid request as an admin' do
      login(admin)
      get dashboard_add_course_path
      expect(response).to render_template(:new_course)
    end

    it 'when it created a valid request as a learner' do
      login(learner)
      get dashboard_add_course_path
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end

  describe 'POST /dashboard/add_course' do
    it 'when created a valid request as an admin or instructor' do
      login(admin)
      expect do
        post dashboard_add_course_path, params:
          {
            course:
              {
                title: 'This is title',
                description: 'This is sample descriptions'
              }
          }
      end.to change(Course, :count).by(1)
      expect(response).to redirect_to dashboard_show_course_path
      expect(flash[:notice]).to eq('This course has been added')
    end

    it 'when created a valid request as a learner' do
      login(learner)
      expect do
        post dashboard_add_course_path, params:
          {
            course:
              {
                title: 'This is title',
                description: 'This is sample descriptions'
              }
          }
      end.to change(Course, :count).by(0)
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end

  describe "GET /dashboard/show_course" do
    it 'when created a valid request as an admin' do
      login(admin)
      get dashboard_show_course_path
      expect(assigns(:page_title)).to eq('Dashboard -> Show courses')
      expect(assigns(:courses)).to be_present
      expect(assigns(:courses)).to match_array(course1)
    end

    it 'when created a valid request as an learner' do
      login(learner)
      get dashboard_show_course_path
      expect(assigns(:courses)).not_to be_present
    end
  end

  describe 'GET /dashboard/show_a_course' do
    it 'when created a valid request it return a page title' do
      login(admin)
      get "/dashboard/show_a_course/#{course1.id}"
      expect(assigns(:page_title)).to eq('Dashboard -> Show a courses')
    end

    it 'when created a valid request as an admin' do
      login(admin)
      get "/dashboard/show_a_course/#{course1.id}"
      expect(response).to render_template(:show_single_course)
    end

    it 'when created a valid request as an admin' do
      login(admin)
      get "/dashboard/show_a_course/#{course1.id}"
      expect(response).to render_template(:show_single_course)
      expect(response).to have_http_status(200)
    end
    it 'when created a valid request as a learner' do
      login(learner)
      get "/dashboard/show_a_course/#{course1.id}"
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end

  describe 'GET /dashboard/edit_course/:id' do
    it 'when created a valid request it return a page title' do
      login(admin)
      get "/dashboard/edit_course/#{course1.id}"
      expect(assigns(:page_title)).to eq('Dashboard -> Edit a course')
    end

    it 'when it created with a valid request as an admin' do
      login(admin)
      get "/dashboard/edit_course/#{course1.id}"
      expect(response).to render_template(:edit_course)
      expect(response).to have_http_status(200)
    end

    it 'when it created with a valid request as a learner' do
      login(learner)
      get "/dashboard/edit_course/#{course1.id}"
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end

  describe 'POST /dashboard/edit_course/:id' do
    it 'when it created a valid request as an admin' do
      login(admin)
      patch "/dashboard/edit_course/#{course1.id}",
            params:
              {
                course:
                  {
                    title: 'This is changed title',
                    description: 'This descriptions has been changed'
                  }
              }
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq('Successfully updated')
    end

    it 'when it created a invalid request as an admin' do
      login(admin)
      patch "/dashboard/edit_course/#{course1.id}",
            params:
              {
                course:
                  {
                    title: "",
                    description: 'This descriptions has been changed'
                  }
              }
      expect(response).to render_template(:new_course)
    end

    it 'when it created a valid request as an admin' do
      login(learner)
      patch "/dashboard/edit_course/#{course1.id}",
            params:
              {
                course:
                  {
                    title: 'This is changed title',
                    description: 'This descriptions has been changed'
                  }
              }
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
      expect(response).to redirect_to(dashboard_show_user_path)
    end
  end

  describe "DELETE /dashboard/delete_course/:id" do
    it 'when it created a valid request as a admin' do
      login(admin)
      delete "/dashboard/delete_course/#{course1.id}"
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq('This course is deleted successfully')
      expect(response).to redirect_to dashboard_show_course_path
    end

    it 'when it created a invalid request as an admin' do
      login(admin)
      delete "/dashboard/delete_course/#{324234}"
      expect(response).to have_http_status(302)
      expect(flash[:notice]).to eq('Please try again!')
      expect(response).to redirect_to dashboard_show_course_path
    end
  end

  def login(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end
end
