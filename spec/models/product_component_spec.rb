# frozen_string_literal: true

# == Schema Information
#
# Table name: product_components
#
#  id           :integer          not null, primary key
#  formula      :string
#  quantity     :decimal(7, 1)    default(0.0), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  component_id :integer          not null
#  product_id   :integer          not null
#
# Indexes
#
#  index_product_components_on_component_id  (component_id)
#  index_product_components_on_product_id    (product_id)
#
# Foreign Keys
#
#  component_id  (component_id => components.id)
#  product_id    (product_id => products.id)
#
require 'rails_helper'

RSpec.describe ProductComponent, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:component).without_validating_presence }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    describe 'after_validation' do
      it 'calls add_errors_to_component_id' do
        product_component = build(:product_component)

        expect(product_component).to receive(:add_errors_to_component_id)

        product_component.valid?
      end

      it 'calls calculate_quantity if component_id is present' do
        product_component = build(:product_component, component_id: 1)

        expect(product_component).to receive(:calculate_quantity)

        product_component.valid?
      end
    end

    describe 'before_save' do
      it 'calls update_quantity' do
        product_component = build(:product_component)

        expect(product_component).to receive(:update_quantity)

        product_component.save
      end
    end

    describe 'after_create' do
      it 'calls update_product_price' do
        product_component = build(:product_component)

        expect(product_component).to receive(:update_product_price)

        product_component.save
      end
    end

    describe 'after_update' do
      it 'calls update_product_price if quantity or component_id has changed' do
        product_component = create(:product_component)

        expect(product_component).to receive(:update_product_price)

        product_component.update(formula: 10_000)
      end
    end

    describe 'after_destroy' do
      it 'calls update_product_price' do
        product_component = create(:product_component)

        expect(product_component).to receive(:update_product_price)

        product_component.destroy
      end
    end
  end

  describe '#update_quantity' do
    it 'updates quantity' do
      product_component = build(:product_component, formula: 'product_height * component_height')

      expect(product_component).to receive(:calculate_quantity)

      product_component.update_quantity
    end
  end

  describe '#calculate_quantity' do
    it 'returns component.min_quantity if formula is blank' do
      product_component = build(:product_component, formula: nil)

      expect(product_component.calculate_quantity).to eq(product_component.component.min_quantity)
    end

    it 'returns the calculated quantity' do
      product = create(:product, height: 10, width: 10)
      component = create(:component, height: 10, length: 10, min_quantity: 1, thickness: 1, weight: 1, width: 10)
      product_component = build(:product_component, product: product, component: component, formula: 'product_height * component_height')

      expect(product_component.calculate_quantity).to eq(100)
    end

    it 'adds an error if the formula is invalid' do
      product_component = build(:product_component, formula: '1 / 0')

      product_component.calculate_quantity

      expect(product_component.errors[:formula]).to include('Dentaku::ZeroDivisionError')
    end
  end

  describe '#update_product_price' do
    it 'calls product.update_price' do
      product_component = build(:product_component)

      expect(product_component.product).to receive(:update_price)

      product_component.update_product_price
    end
  end
end
