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

  describe 'GET /balances.pdf' do
    let!(:transaction) do
      create(:transaction,
             order: order,
             type_id: 'salary',
             amount: 1500,
             date: Time.zone.today,
             description: 'Test salary payment')
    end

    it 'generates PDF and includes transaction data' do
      get balances_path(format: :pdf), params: { from: Time.zone.today - 1, to: Time.zone.today + 1 }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq 'application/pdf'

      text = PDF::Reader.new(StringIO.new(response.body)).pages.map(&:text).join

      expect(text).to include('Balance Report')
      expect(text).to include('salary')
      expect(text).to include('1500.00')
      expect(text).to include('Test salary payment')
    end
  end
end
