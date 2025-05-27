# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ComponentsOrders', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company:) }
  let(:client) { create(:client, company:) }

  let!(:supplier1) { create(:supplier, name: 'Подрядчик 1') }
  let!(:supplier2) { create(:supplier, name: 'Подрядчик 2') }

  let!(:component1) { create(:component, name: 'Компонент 1', code: 'C1', supplier: supplier1, category: 'aluminum') }
  let!(:component2) { create(:component, name: 'Компонент 2', code: 'C2', supplier: supplier1, category: 'aluminum') }
  let!(:component3) { create(:component, name: 'Компонент 3', code: 'C3', supplier: supplier2, category: 'aluminum') }

  let!(:order) { create(:order, name: 'Company Order', company:) }
  let!(:version) { create(:order_version, order: order, final_version: true) }

  let!(:product1) do
    create(:product, order_version: version, quantity: 2).tap do |product|
      create(:product_component, product: product, component: component1, formula: 2)
      create(:product_component, product: product, component: component2, formula: 4)
    end
  end

  let!(:product2) do
    create(:product, order_version: version, quantity: 1).tap do |product|
      create(:product_component, product: product, component: component3, formula: 33)
    end
  end

  before { sign_in user }

  describe 'GET /orders/:id/components_orders' do
    it 'группирует компоненты по подрядчику и считает количество' do
      get order_components_orders_path(order)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Компонент 1')
      expect(response.body).to include('Компонент 2')
      expect(response.body).to include('Компонент 3')
      expect(response.body).to include('4') # 2 x 2
      expect(response.body).to include('8') # 4 x 2
      expect(response.body).to include('33') # 33 x 1

      # Проверим, что компоненты отображаются в нужной группе:
      expect(response.body).to include('Подрядчик 1')
      expect(response.body).to include('Подрядчик 2')
    end
  end

  describe 'GET /orders/:id/components_orders/print?supplier_id=...' do
    it 'показывает только компоненты нужного подрядчика' do
      get print_order_components_orders_path(order, supplier_id: supplier1.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Компонент 1')
      expect(response.body).to include('Компонент 2')
      expect(response.body).to include('4')
      expect(response.body).to include('8')

      expect(response.body).not_to include('Компонент 3')
      expect(response.body).not_to include('33')
    end
  end
end
