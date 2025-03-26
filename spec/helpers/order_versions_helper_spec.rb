# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderVersionsHelper, type: :helper do
  describe '#order_version_tabs' do
    let(:order) { create(:order) }
    let(:order_versions) { create_list(:order_version, 2, order: order) }

    it 'renders tabs with buttons and panels' do
      result = helper.order_version_tabs(order, order_versions)

      expect(result).to include('tabs__list')
      expect(result).to include('New Version')
      order_versions.each do |version|
        expect(result).to include("trigger_#{version.id}")
        expect(result).to include("V#{order_versions.size - order_versions.index(version)}")
      end
    end

    describe '#order_versions_buttons' do
      it 'generates correct buttons' do
        buttons = helper.send(:order_versions_buttons, order, order_versions)

        expect(buttons.size).to eq(order_versions.size + 1) # +1 for new version button
        expect(buttons.first).to include('New Version')

        order_versions.each_with_index do |version, index|
          expect(buttons[index + 1]).to include("V#{order_versions.size - index}")
          expect(buttons[index + 1]).to include(version.created_at.strftime('%d-%m-%Y'))
        end
      end
    end
  end

  describe '#new_product' do
    let(:order_version) { create(:order_version) }

    it 'creates new product with order version' do
      product = helper.new_product(order_version)
      expect(product).to be_a(Product)
      expect(product.order_version).to eq(order_version)
    end
  end
end
