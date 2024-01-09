require 'rails_helper'
RSpec.describe "Sessions", type: :request do
  include AuthenticationHelper
  let(:user1) { FactoryBot.create(:user) }
  before(:each) do
  
  end
  describe 'POST /login' do
    let!(:user) { { user: { email: 'shorojit.kumar@welldev.io', password: 'Pass321' } } }
    it 'redirect to home if success' do
      post '/login', params: user
      expect(response).to redirect_to('/')
    end
    it 'renders new template if credentials are wrong' do
      post '/login', params: { user: { email: 'shorojit.kumar@welldev.io', password: 'Pass341' } }
      expect(response).to have_http_status(:unprocessable_entity)
      post '/login', params: { user: { email: 'shorojit.kum1ar@welldev.io', password: 'Pass341' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    # it 'should logged In user' do
    #   post '/sign_in', params: user
    #   expect(session[:current_user_id]).to eq(current_user.id)
    #   expect(response).to have_http_status(:see_other)
    # end
  end
  describe 'DELETE /Logout' do
    it 'should logout' do
      delete '/logout'
      expect(response).to redirect_to(root_path)
      expect(response).to have_http_status(:found)
      expect(session[:user_id]).to eq(nil)
      expect(flash[:notice]).to eq('Signed out')
    end
  end
end
