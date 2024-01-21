# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Passwords', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  describe 'GET /new_password_path' do
    it 'render template' do
      logout
      get new_password_path
      expect(response).to render_template 'passwords/new'
    end
    it 'have status code' do
      logout
      get new_password_path
      expect(response).to have_http_status(:ok)
    end
  end
  describe 'POST /password' do
    it 'when get a valid email' do
      post passwords_path, params: { user: { email: user.email } }
      expect(response).to redirect_to root_path
    end
    it 'when get a valid email have status' do
      post passwords_path, params: { user: { email: user.email } }
      expect(response).to have_http_status(:found)
    end
    it 'when get a valid email then a user get notice' do
      post passwords_path, params: { user: { email: user.email } }
      expect(flash[:notice]).to eq('Reset instruction is sent to user emails')
    end
    it 'when get a valid email but unconfirmed then have status' do
      post passwords_path, params: { user: { email: user.email } }
      expect(response).to have_http_status(:found)
    end
    it 'when get a valid email but unconfirmed return alert' do
      allow_any_instance_of(User).to receive(:confirmed?).and_return(false)
      post passwords_path, params: { user: { email: user.email } }
      expect(flash[:notice]).to eq('Please confirm email first.')
    end
    it 'when get a invalid email' do
      post passwords_path, params: { user: { email: 'random@gmail.com' } }
      expect(flash[:notice]).to eq('Please provide correct email')
    end
  end
  describe 'GET /passwords/password_reset_token' do
    it 'when it requested with valid token it render edit page' do
      password_reset_token = user.generate_password_reset_token
      get "/passwords/#{password_reset_token}/edit"
      expect(response).to render_template :edit
    end
    it 'when it requested with valid token but user is unconfirmed' do
      allow_any_instance_of(User).to receive(:unconfirmed?).and_return(true)
      password_reset_token = user.generate_password_reset_token
      get "/passwords/#{password_reset_token}/edit"
      expect(response).to redirect_to(new_confirmation_path)
    end
    it 'when it requested with valid token but user is unconfirmed' do
      allow_any_instance_of(User).to receive(:unconfirmed?).and_return(true)
      password_reset_token = user.generate_password_reset_token
      get "/passwords/#{password_reset_token}/edit"
      expect(flash[:notice]).to eq('You must have confirm email before sign in')
    end
    it 'when it requested with invalid token it redirect to new password path' do
      get '/passwords/fasfdasdasdasdfaseasdfasdfas/edit'
      expect(response).to redirect_to(new_password_path)
    end
    it 'when it requested with invalid token return an alert' do
      get '/passwords/fasfdasdasdasdfaseasdfasdfas/edit'
      expect(flash[:notice]).to eq('Invalid or expired token')
    end
  end

  describe 'POST /passwords/password_reset_token' do
    it 'when it requested with valid password_reset_token' do
      password_reset_token = user.generate_password_reset_token
      put "/passwords/#{password_reset_token}",
           params: { user: { password: user.password, password_confirmation: user.password_confirmation } }
      expect(response).to redirect_to(login_path)
      expect(flash[:notice]).to eq('Sign in')
    end
    it 'when it requested with valid password_reset_token but user is unconfirmed' do
      allow_any_instance_of(User).to receive(:unconfirmed?).and_return(true)
      password_reset_token = user.generate_password_reset_token
      put "/passwords/#{password_reset_token}",
          params: { user: { password: user.password, password_confirmation: user.password_confirmation } }
      expect(response).to redirect_to(new_confirmation_path)
      expect(flash[:notice]).to eq('You must have confirm email before login')
    end
    it 'when it requested with invalid password_reset_token' do
      put "/passwords/sdfasdfasdasdasd",
          params: { user: { password: user.password, password_confirmation: user.password_confirmation } }
      expect(response).to render_template :new
    end
    it 'when it requested with invalid password_reset_token' do
      put "/passwords/sdfasdfasdasdasd",
          params: { user: { password: user.password, password_confirmation: user.password_confirmation } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  def logout
    delete logout_path
  end
end
