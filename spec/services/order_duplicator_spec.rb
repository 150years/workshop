# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderDuplicator, type: :service do
  let(:company) { create(:company) }
  let(:client) { create(:client, company: company) }
  let(:order) { create(:order, company: company, client: client) }

  let!(:order_version) do
    create(:order_version, order: order, company: company, final_version: true)
  end

  let!(:product) do
    create(:product, order_version: order_version, company: company, quantity: 2).tap do |p|
      # добавим image
      p.image.attach(
        io: Rails.root.join('spec/fixtures/files/image.jpg').open,
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end
  end

  let!(:component) { create(:component) }

  let!(:product_component) do
    create(:product_component, product: product, component: component, quantity: 3)
  end

  describe '.duplicate_order' do
    it 'creates a new order with duplicated version, products and components' do
      new_order = OrderDuplicator.duplicate_order(order)

      expect(new_order).not_to eq(order)
      expect(new_order.order_versions.count).to eq(1)

      new_version = new_order.order_versions.first
      expect(new_version.products.count).to eq(1)

      new_product = new_version.products.first
      expect(new_product.product_components.count).to eq(1)
      expect(new_product.image).to be_attached
    end
  end

  describe '.duplicate_version' do
    it 'creates a new version in the same order' do
      new_version = OrderDuplicator.duplicate_version(order_version)

      expect(new_version.order).to eq(order)
      expect(new_version).not_to eq(order_version)
      expect(new_version.products.count).to eq(1)
      expect(new_version.products.first.product_components.count).to eq(1)
    end
  end
end
