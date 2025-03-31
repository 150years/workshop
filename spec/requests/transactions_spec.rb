# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'GET /index' do
    it 'returns http success' do
      get '/transactions/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/transactions/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }

    before do
      sign_in user
    end

    it 'creates a new transaction' do
      post transactions_path, params: {
        transaction: {
          date: Time.zone.today,
          description: 'Spec income',
          amount: 5000,
          type_id: 'payment' # ✅ именно строка enum-а
        }
      }

      expect(response).to redirect_to(transactions_path)
    end
  end
end
