# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StockMovements', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company:) }
  let(:component) { create(:component, company:) }
  let(:order) { create(:order, company:) }
  let!(:inbound) { create(:stock_movement, component:, movement_type: :inbound, quantity: 100) }
  let!(:stock_movement) { create(:stock_movement, component:, order:, movement_type: :to_project, quantity: 50) }

  before do
    sign_in user
  end

  describe 'GET /stock_movements' do
    it 'returns 200' do
      get stock_movements_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /stock_movements/summary' do
    it 'returns 200' do
      get summary_stock_movements_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /stock_movements/new' do
    it 'returns 200' do
      get new_stock_movement_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /stock_movements/:id/edit' do
    it 'returns 200' do
      get edit_stock_movement_path(stock_movement)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /stock_movements' do
    it 'creates and redirects' do
      post stock_movements_path, params: {
        stock_movement: {
          component_id: component.id,
          order_id: order.id,
          quantity: 5,
          movement_type: :to_project,
          comment: 'Test'
        }
      }
      expect(response).to have_http_status(:found) # redirect
    end
  end

  describe 'PATCH /stock_movements/:id' do
    it 'updates and redirects' do
      patch stock_movement_path(stock_movement), params: {
        stock_movement: {
          component_id: component.id,
          order_id: order.id,
          movement_type: :to_project,
          quantity: 30,
          comment: 'Valid update'
        }
      }
      expect(response).to have_http_status(:found)
    end

    it 'fails to update if quantity exceeds stock' do
      patch stock_movement_path(stock_movement), params: {
        stock_movement: {
          component_id: component.id,
          order_id: order.id,
          movement_type: :to_project,
          quantity: 999,
          comment: 'Too much'
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('Quantity exceeds available stock')
    end
  end

  describe 'DELETE /stock_movements/:id' do
    it 'deletes and redirects' do
      delete stock_movement_path(stock_movement)
      expect(response).to have_http_status(:found)
    end
  end
end
