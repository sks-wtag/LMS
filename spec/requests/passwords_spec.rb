require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  describe "GET /new_password_path" do
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
      post passwords_path, params: { user: {email: user.email } }
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
      expect(flash[:alert]).to eq('Please confirm email first.')
    end
    it 'when get a invalid email' do
      post passwords_path, params: { user: { email: 'random@gmail.com' } }
      expect(flash[:alert]).to eq('Please provide correct email')
    end
  end
  
  # def login(user)
  #   post login_path, params: { user: { email: user.email, password: user.password } }
  # end

  def logout
    delete logout_path
  end
end
