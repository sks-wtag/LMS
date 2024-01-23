# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Confirmations', type: :request do
  let!(:user) { create(:user) }
  describe 'GET /new' do
    it 'when it requested it will return a confirm password form' do
      get new_password_path
      expect(response).to render_template :new
    end
  end
  describe 'GET /confirmations' do
    it 'when it requested with valid email and if user is unconfirmed then it send mail and redirect to root path' do
      allow_any_instance_of(User).to receive(:unconfirmed?).and_return(true)
      post confirmations_path, params: { user: { email: user.email } }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Please check your email for confirmation instructions')
    end
    it 'when it requested with valid email and if user is confirmed then it redirect to new confirmation path' do
      post confirmations_path, params: { user: { email: user.email } }
      expect(response).to redirect_to(new_confirmation_path)
      expect(flash[:notice]).to eq("Invalid Email or Password!")
    end
  end
  describe 'GET /confirmations/:confirmation_token/edit' do
    it 'when it requested with valid confirmation token then it login user and redirect to root path' do
      get "/confirmations/#{user.generate_confirmation_token}/edit"
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq('Your account has been confirmed')
    end
    it 'when it requested with valid email and if user is unconfirmed then it redirect to new confirmation path' do
      allow_any_instance_of(User).to receive(:confirm!).and_return(false)
      get "/confirmations/#{user.generate_confirmation_token}/edit"
      expect(response).to redirect_to(new_confirmation_path)
      expect(flash[:notice]).to eq('Invalid token')
    end
  end
end
