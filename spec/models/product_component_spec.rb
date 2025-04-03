# frozen_string_literal: true

# == Schema Information
#
# Table name: product_components
#
#  id            :integer          not null, primary key
#  formula       :string
#  quantity      :decimal(7, 1)    default(0.0), not null
#  quantity_real :decimal(7, 1)    default(0.0), not null
#  ratio         :decimal(3, 2)    default(0.0)
#  waste         :decimal(7, 1)    default(0.0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  component_id  :integer          not null
#  product_id    :integer          not null
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
    it { is_expected.to validate_presence_of(:quantity_real) }
    it { is_expected.to validate_numericality_of(:quantity_real).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:ratio) }
    it { is_expected.to validate_numericality_of(:ratio).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_presence_of(:waste) }
    it { is_expected.to validate_numericality_of(:waste).is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    describe 'after_validation' do
      it 'calls add_errors_to_component_id' do
        product_component = build(:product_component)

        expect(product_component).to receive(:add_errors_to_component_id)

        product_component.valid?
      end

      it 'calls calculate_quantity_real if component_id is present' do
        product_component = build(:product_component, component_id: 1)

        expect(product_component).to receive(:calculate_quantity_real)

        product_component.valid?
      end
    end

    describe 'before_save' do
      it 'calls set_quantity_fields' do
        product_component = build(:product_component)

        expect(product_component).to receive(:set_quantity_fields)

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

  describe '#set_quantity_fields' do
    describe 'quantity_real and calculate_quantity_real' do
      it 'sets quantity_real' do
        product_component = build(:product_component, formula: 'product_height * component_height')

        expect(product_component).to receive(:calculate_quantity_real)

        product_component.set_quantity_fields
      end

      describe '#calculate_quantity_real' do
        it 'returns the calculated quantity' do
          product = create(:product, height: 10_000, width: 10)
          component = create(:component, height: 10_000, length: 10, min_quantity: 1, thickness: 1, weight: 1, width: 10)
          product_component = build(:product_component, product: product, component: component, formula: 'product_height * component_height')

          product_component.set_quantity_fields

          expect(product_component.quantity_real).to eq(100)
        end

        it 'returns component.min_quantity if formula is blank' do
          product_component = build(:product_component, formula: nil)

          product_component.set_quantity_fields

          expect(product_component.quantity_real).to eq(product_component.component.min_quantity)
        end

        it "uses the cached value if it's present" do
          product_component = build(:product_component, formula: 'product_height * component_height')
          product_component.instance_variable_set(:@calculated_quantity_real, 999)

          product_component.set_quantity_fields

          expect(product_component.quantity_real).to eq(999)
        end

        describe 'calculation_variables' do
          ProductComponent::CALCULATION_VARIABLES.each_key do |variable|
            it "accepts #{variable}" do
              product = create(:product, height: 10, width: 10)
              component = create(:component, height: 10, length: 10, min_quantity: 1, thickness: 1, weight: 1, width: 10)
              product_component = build(:product_component, product: product, component: component, formula: variable)

              product_component.set_quantity_fields

              expect(product_component).to be_valid
            end
          end

          it 'adds an error if a variable is missing' do
            product_component = build(:product_component, formula: 'missing_variable')

            product_component.set_quantity_fields

            expect(product_component.errors[:formula]).to include('no value provided for variables: missing_variable')
          end
        end

        it 'adds an error if the formula is invalid' do
          product_component = build(:product_component, formula: '1 / 0')

          product_component.set_quantity_fields

          expect(product_component.errors[:formula]).to include('Dentaku::ZeroDivisionError')
        end
      end
    end
  end

  describe 'quantity and calculate_quantity' do
    it 'sets quantity' do
      product_component = build(:product_component, formula: 'product_height * component_height')

      expect(product_component).to receive(:calculate_quantity)

      product_component.set_quantity_fields
    end

    describe '#calculate_quantity' do
      it 'return real quantity' do
        product = create(:product, height: 10, width: 10)
        component = create(:component, height: 10, length: 10, min_quantity: 1, thickness: 1, weight: 1, width: 10)
        product_component = build(:product_component, product: product, component: component, formula: 'product_height * component_height')

        product_component.set_quantity_fields

        expect(product_component.quantity).to eq(product_component.quantity_real)
      end

      context 'when component unit is lines' do
        it 'rounds up the quantity' do
          product = create(:product, height: 10)
          component = create(:component, height: 3, unit: 'lines')
          product_component = build(:product_component, product: product, component: component, formula: 'product_height / component_height')

          product_component.set_quantity_fields

          expect(product_component.quantity).not_to eq(product_component.quantity_real)
          expect(product_component.quantity).to eq(4)
        end
      end
    end
  end

  describe 'waste and calculate_waste' do
    it 'sets waste' do
      product_component = build(:product_component, formula: 'product_height * component_height')

      expect(product_component).to receive(:calculate_waste)

      product_component.set_quantity_fields
    end

    describe '#calculate_waste' do
      it 'returns the calculated waste' do
        product = create(:product, height: 10, width: 10)
        component = create(:component, height: 10, length: 10, min_quantity: 1, thickness: 1, weight: 1, width: 10)
        product_component = build(:product_component, product: product, component: component, formula: 'product_height * component_height')

        product_component.set_quantity_fields

        expect(product_component.waste).to eq(0)
      end

      it 'returns 0 if quantity_real is 0' do
        product_component = build(:product_component)

        allow(product_component).to receive(:quantity_real).and_return(0)

        product_component.set_quantity_fields

        expect(product_component.waste).to eq(0)
      end

      it 'returns 0 if quantity is 0' do
        product_component = build(:product_component)

        allow(product_component).to receive(:quantity).and_return(0)

        product_component.set_quantity_fields

        expect(product_component.waste).to eq(0)
      end
    end

    describe 'ratio and calculate_ratio' do
      it 'sets ratio' do
        product_component = build(:product_component, formula: 'product_height * component_height')

        expect(product_component).to receive(:calculate_ratio)

        product_component.set_quantity_fields
      end

      describe '#calculate_ratio' do
        it 'returns the calculated ratio' do
          component = create(:component, height: 10, length: 3, unit: 'lines')
          product_component = build(:product_component, component: component, formula: 'component_height / component_length')

          product_component.set_quantity_fields

          expect(product_component.ratio).to eq(0.83)
        end

        it 'returns 0 if quantity_real is 0' do
          product_component = build(:product_component)

          allow(product_component).to receive(:quantity_real).and_return(0)

          product_component.set_quantity_fields

          expect(product_component.ratio).to eq(0)
        end

        it 'returns 0 if quantity is 0' do
          product_component = build(:product_component)

          allow(product_component).to receive(:quantity).and_return(0)

          product_component.set_quantity_fields

          expect(product_component.ratio).to eq(0)
        end
      end
    end

    it 'sets cached @calculated_quantity_real to nil' do
      product_component = build(:product_component, formula: 'product_height * component_height')
      product_component.instance_variable_set(:@calculated_quantity_real, 100)

      product_component.set_quantity_fields

      expect(product_component.instance_variable_get(:@calculated_quantity_real)).to be_nil
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
