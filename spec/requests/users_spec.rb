# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:organization) { FactoryBot.create(:organization) }
  let!(:user) { FactoryBot.create(:user)}
  describe 'GET /sign_up' do
    it 'return a sign_up view with status code success' do
      get '/sign_up'
      expect(response).to render_template :new
      expect(response).to have_http_status(:success)
    end
  end
  describe 'POST /sign_up' do
    let(:valid_organization) do
      {
        organization: attributes_for(
          :organization,
          users_attributes: { '0' => attributes_for(:user) }
        )
      }
    end
    let(:invalid_organization) do
      {
        organization:
          {
            name: "Invalid",
            users_attributes:
              {
                "0" => {
                  first_name: 'Shorojit',
                  last_name: 'Sarkar',
                  email: 'shorojitsarkar1997@gmail.com',
                  phone: '2341231231',
                  password: '123456',
                  password_confirmation: '654322',
                  confirmed_at: Time.now,
                  role: 2,
                  status: 1
                }
              }
          }
      }
    end
    it 'when successfully created a new user' do
      expect do
        post '/sign_up', params: valid_organization
      end.to change(User, :count).by(1)
    end
    it 'when successfully created a new user it redirect root path' do
      post '/sign_up', params: valid_organization
      expect(response).to redirect_to root_path
    end
    it 'when successfully created a new user return status 201' do
      post '/sign_up', params: valid_organization
      expect(response).to have_http_status(:found)
    end
    it 'when request is invalid' do
      expect do
        post '/sign_up', params: invalid_organization
      end.to change(User, :count).by(0)
    end
    it 'when request is invalid it render new signup page' do
      post '/sign_up', params: invalid_organization
      expect(response).to render_template :new
    end
    it 'when request is invalid it return status code :unprocessable_entity' do
      post '/sign_up', params: invalid_organization
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'GET /user/change_password' do
    before do
      allow_any_instance_of(AuthenticationHelper).to receive(:user_signed_in?).and_return(user.present?)
      allow_any_instance_of(AuthenticationHelper).to receive(:current_user).and_return(user)
    end
    it 'it return edit_password template' do
      get '/user/change_password'
      expect(response).to render_template :edit_password
    end
    it 'it return status code :ok' do
      get '/user/change_password'
      expect(response).to have_http_status(:ok)
    end

  end
  describe 'Post /user/change_password' do
    before do
      allow_any_instance_of(AuthenticationHelper).to receive(:user_signed_in?).and_return(user.present?)
      allow_any_instance_of(AuthenticationHelper).to receive(:current_user).and_return(user)
    end
    it 'when valid request is created' do
      post '/user/change_password', params: { user: { email: user.email, current_password: user.password, password: 'Pass123', password_confirmation: 'Pass123' } }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Password updated')
    end
  end

  describe 'Delete /user/delete' do
    it 'when it requested it will delete a current user' do
      login
      delete user_delete_path
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('This user account has been deleted')
    end
  end
  describe 'GET /user/update' do
    it 'when it requested it will return a edit form' do
      login
      get user_update_path
      expect(response).to render_template :edit
    end
  end

  describe 'Post /user/update' do
    it 'when it requested with valid params it will redirect to root path' do
      login
      post user_update_path, params: { user: { first_name: 'Shuvo', last_name: 'Khan', phone: '01712198113', address: 'Whole universe is my address' } }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Account updated')
    end
    it 'when it requested with invalid params it will redirect to root path' do
      login
      post user_update_path, params: { user: { first_name: '', last_name: 'Khan', phone: '01712198113', address: 'Whole universe is my address' } }
      expect(response).to render_template :edit
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  def login
    post login_path, params: { user: { email: user.email, password: user.password } }
  end

end
