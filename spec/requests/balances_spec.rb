# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Balances', type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'returns http success' do
      get balances_path
      expect(response).to have_http_status(:success)
    end
  end
end
