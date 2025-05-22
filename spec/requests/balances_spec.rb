# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Balances', type: :request do
  let(:user) { create(:user) }
  let!(:order) { create(:order, company: user.company) }
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
end
