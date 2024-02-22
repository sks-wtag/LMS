# frozen_string_literal: true
require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET /home' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:home)
    end
  end

end
