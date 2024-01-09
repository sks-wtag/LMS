# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe 'GET /sign_up' do
    it 'Get /sign_up' do
      get '/sign_up'
      expect(response).to have_http_status(:success)
    end
  end
  describe 'GET /login' do
    it 'Get /login' do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end
  
end
