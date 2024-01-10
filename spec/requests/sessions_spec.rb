require 'rails_helper'
RSpec.describe "Sessions", type: :request do
  let!(:user1) { FactoryBot.create(:user) }
  before(:each) do
    allow_any_instance_of(AuthenticationHelper).to receive(:current_user).and_return(user1)
    allow_any_instance_of(AuthenticationHelper).to receive(:user_signed_in?).and_return(user1.present?)
    allow_any_instance_of(AuthenticationHelper).to receive(:current_user_id).and_return(user1.id)
  end
  describe 'POST /login' do
    let!(:user) { { user: { email: user1.email, password: 'Pass321' } } }
    it 'redirect to home if success' do
      post '/login', params: user
      expect(response).to redirect_to('/')
    end
    it 'renders new template if credentials are wrong' do
      post '/login', params: { user: { email: user1.present?, password: 'Pass341' } }
      expect(response).to have_http_status(:unprocessable_entity)
      post '/login', params: { user: { email: user1.present?, password: 'Pass341' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
    it 'should logged In user' do
      post '/login', params: user
      expect(session[:current_user_id]).to eq(current_user.id)
      expect(response).to redirect_to('/')
    end
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
