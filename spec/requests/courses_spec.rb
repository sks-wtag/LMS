require 'rails_helper'

RSpec.describe "Courses", type: :request do
  let!(:user) { create(:user,role: "admin") }
  before do
    login(user)
  end
  describe "GET /dashboard/add_course" do

    it 'when it created a valid request' do
      login(user)
      get dashboard_add_course_path
      expect(response).to render_template(:new_course)
    end

  end
  def login(user)
    post login_path, params: { user: { email: user.email, password: user.password}}
  end
end
