# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Dashboards', type: :request do
  let!(:user) { create(:user) }
  before do
    login(user)
  end
  describe 'GET /index' do
    it 'it return a dashboard page' do
      get dashboard_path
      expect(response).to render_template(:index)
    end
  end
  describe 'GET /dashboard/add_user' do
    it 'When a user role is admin then it return a new form ' do
      get dashboard_add_user_path
      expect(response).to render_template(:new_user)
    end
    it 'When a user role is learner or instructor it can not access this route' do
      user.update(role: 'instructor')
      get dashboard_add_user_path
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end
  describe 'POST /dashboard/add_user' do
    let(:valid_user) { attributes_for(:user) }
    let(:invalid_user) {
      {
        user: {
          first_name: 'sdlfsdf',
          last_name: 'dsaf',
          email: 'example@gmail.com',
          phone: '12308210',
        }
      }
    }
    it 'When a request is created with valid params for adding a user it redirect show user path' do
      post dashboard_add_user_path, params: { user: valid_user }
      expect(response).to redirect_to(dashboard_show_user_path)
    end
    it 'When a request is created with valid params for adding a user it return a flash message' do
      post dashboard_add_user_path, params: { user: valid_user }
      expect(flash[:notice]).to eq('Added a user successfully')
    end
    it 'When a request is created with invalid params for adding a user it render the new_user page' do
      post dashboard_add_user_path, params: { user: invalid_user }
      expect(response).to render_template :new_user
    end
  end
  describe 'POST /dashboard/change_status/:id' do
    it 'When created a valid request as a admin' do
      get "/dashboard/change_status/#{user.id}"
      expect(response).to redirect_to dashboard_show_user_path
      expect(flash[:notice]).to eq('Status successfully updated.')
    end
    it 'When created a invalid request as a admin' do
      get "/dashboard/change_status/#{123123}"
      expect(response).to redirect_to dashboard_show_user_path
      expect(flash[:notice]).to eq('Please try again')
    end
    it 'When created a valid request as a learner or instructor' do
      user.update(role: 'instructor')
      get "/dashboard/change_status/#{user.id}"
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end
  describe "GET /dashboard/show_user" do
    let!(:active_user) { create(:user) }
    let!(:inactive_user) { create(:user) }
    it 'when created a valid request as a admin' do
      inactive_user.update(status: 'Inactive')
      get dashboard_show_user_path
      expect(assigns(:users)).to match_array([user, active_user, inactive_user])
    end
    it 'when created a valid request as a instructor or learner' do
      user.update(role: 'learner')
      inactive_user.update(status: 'Inactive')
      get dashboard_show_user_path
      expect(assigns(:users)).to match_array([user, active_user])
    end
    it 'when created a valid request it return show_user page' do
      get dashboard_show_user_path
      expect(response).to render_template(:show_user)
    end
  end
  describe "DELETE /dashboard/delete_user" do
    let!(:active_user) { create(:user) }
    it 'When created a valid request as a admin' do
      delete "/dashboard/delete_user/#{active_user.id}"
      expect(response).to redirect_to(dashboard_show_user_path)
    end
    it 'When created a valid request as a learner or instructor' do
      user.update(role: 'learner')
      delete "/dashboard/delete_user/#{active_user.id}"
      expect(flash[:notice]).to eq('You are not authorized to perform this action.')
    end
  end

  def login(user)
    post login_path, params: { user: { email: user.email, password: user.password}}
  end
end
