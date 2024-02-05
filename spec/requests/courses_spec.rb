require 'rails_helper'

RSpec.describe "Courses", type: :request do
  let!(:admin) { create(:user, role: "admin") }
  let!(:instructor) { create(:user, role: "instructor") }
  let!(:learner) { create(:user, role: "learner") }

  describe "GET /dashboard/add_course" do
    it 'when it created a valid request as a admin' do
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
    it 'when created a valid request as a admin or instructor' do
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

    it 'when created a valid request as a admin' do
      login(learner)
      get dashboard_show_course_path

    end
  end

  def login(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end
end
