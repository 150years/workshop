# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Transactions', type: :request do
  let(:user) { create(:user) }
  before { sign_in user }

  describe 'GET /index' do
    it 'returns http success' do
      get '/transactions'
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

      expect(response).to redirect_to(balances_path)
    end
  end

  describe 'PATCH /update' do
    let!(:transaction) { create(:transaction, date: Time.zone.today, amount: 1000, description: 'Original', type_id: 'payment') }

    it 'updates the transaction' do
      patch transaction_path(transaction), params: {
        transaction: {
          amount: 2500,
          description: 'Updated by spec'
        }
      }

      expect(response).to redirect_to(balances_path)
      transaction.reload
      expect(transaction.amount).to eq(2500)
      expect(transaction.description).to eq('Updated by spec')
    end
  end

  describe 'PATCH /update restrictions' do
    let!(:recent_transaction) { create(:transaction, date: Time.zone.today, created_at: 2.days.ago, amount: 1000) }
    let!(:old_transaction)    { create(:transaction, date: Time.zone.today, created_at: 10.days.ago, amount: 1000) }

    it 'allows updating recent transaction' do
      patch transaction_path(recent_transaction), params: {
        transaction: { amount: 2000 }
      }

      expect(response).to redirect_to(balances_path)
      follow_redirect!
      expect(response.body).to include('Transaction updated')

      recent_transaction.reload
      expect(recent_transaction.amount).to eq(2000)
    end

    it 'blocks updating old transaction' do
      patch transaction_path(old_transaction), params: {
        transaction: { amount: 2000 }
      }

      expect(response).to redirect_to(balances_path)
      follow_redirect!
      expect(response.body).to include('Editing not allowed after 7 days.')

      old_transaction.reload
      expect(old_transaction.amount).to eq(1000)
    end
  end
end
