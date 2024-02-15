require 'rails_helper'
RSpec.describe "Sessions", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  describe  'GET /login' do
    it 'return new login page' do
      get '/login'
      expect(response).to render_template :new
    end
  end
  
  describe 'POST /login' do
    it 'redirect to home if success' do
      post '/login', params: { user: { email: user.email, password: user.password } }
      expect(response).to have_http_status(302)
      expect(session[:current_user_id]).to eq(user.id)
    end
    it 'renders new template if credentials are wrong' do
      post '/login', params: { user: { email: user.email, password: 'Pass341' } }
      expect(response).to have_http_status(:unprocessable_entity)
      post '/login', params: { user: { email: 'random@gmail.com', password: 'Pass341' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  describe 'DELETE /Logout' do
    it 'should logout' do
      delete '/logout'
      expect(response).to redirect_to(root_path)
      expect(response).to have_http_status(:found)
      expect(flash[:notice]).to eq(I18n.t('errors.messages.logged_out'))
    end
  end
end
