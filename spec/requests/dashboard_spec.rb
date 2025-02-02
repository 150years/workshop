# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :request do
  let(:user) { create(:user) }

  before do
    login_as user
  end

  describe 'GET /index' do
    it 'returns http success' do
      get root_path
      expect(response).to have_http_status(:success)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
