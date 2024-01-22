require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let!(:user) {create(:user)}
  before do
    login
  end
  describe "GET /index" do
    it 'it return a dashboard page' do
      get dashboard_path
      expect(response).to render_template(:index)
    end
  end
  describe "GET /dashboard/add_user" do
    it 'it return a new form ' do
      get dashboard_add_user_path
      expect(response).to render_template(:new_user)
    end
  end

  def login
    post login_path, params: { user: { email: user.email, password: user.password}}
  end
end
