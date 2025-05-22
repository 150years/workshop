# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Balances', type: :request do
  let(:user) { create(:user) }
  let!(:order) { create(:order, company: user.company, name: 'Test Project') }
  let!(:matching_transaction) { create(:transaction, order: order, type_id: 'salary', date: Time.zone.today) }
  let!(:other_transaction) { create(:transaction, type_id: 'taxes', date: Time.zone.today - 10) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'returns http success' do
      get balances_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /balances with filters' do
    it 'applies filters by type and order' do
      get balances_path(type_id: 'salary', order_id: order.id)
      expect(response.body).to include(matching_transaction.description.to_s)
      expect(response.body).not_to include(other_transaction.description.to_s)
    end
  end

  let!(:visible_tx) { create(:transaction, amount: 1000, order: order, hidden: false, only_for_accounting: false, date: Time.zone.today) }
  let!(:hidden_tx)  { create(:transaction, amount: 2000, order: order, hidden: true, only_for_accounting: false, date: Time.zone.today) }
  let!(:accounting_tx) { create(:transaction, amount: 3500, order: order, hidden: false, only_for_accounting: true, date: Time.zone.today) }

  describe 'GET /balances' do
    it 'shows only non-accounting transactions in full mode' do
      get balances_path(mode: 'full')

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Test Project')
      expect(response.body).to include(visible_tx.amount_money.format)
      expect(response.body).not_to include(accounting_tx.amount_money.format)
    end

    it 'shows only non-hidden transactions in acc mode' do
      get balances_path(mode: 'acc')

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Test Project')
      expect(response.body).to include(accounting_tx.amount_money.format)
      expect(response.body).not_to include(hidden_tx.amount_money.format)
    end
  end

  describe 'GET /balances/print' do
    it 'renders balance_preview in full mode without errors' do
      get print_balances_path(mode: 'full')

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Balance Report')
      expect(response.body).to include(visible_tx.date.strftime('%d.%m.%Y'))
    end

    it 'renders accounting balance in acc mode' do
      get print_balances_path(mode: 'acc')

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(accounting_tx.amount_money.format)
      expect(response.body).not_to include(hidden_tx.amount_money.format)
    end
  end
end
