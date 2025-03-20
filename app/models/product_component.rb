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
class ProductComponent < ApplicationRecord
  belongs_to :product
  belongs_to :component

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_validation :add_errors_to_component_id
  after_validation :calculate_quantity
  before_save :update_quantity
  after_create :update_product_price
  after_update :update_product_price, if: -> { saved_change_to_quantity? || saved_change_to_component_id? }
  after_destroy :update_product_price

  def self.ransackable_attributes(_auth_object = nil)
    %w[id component_id product_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[products]
  end

  def update_product_price
    product.update_price
  end

  def update_quantity
    self.quantity = calculate_quantity
  end

  def calculate_quantity
    return component.min_quantity if formula.blank?

    calculator = Dentaku::Calculator.new

    variables = {
      product_height: product.height,
      product_width: product.width,
      component_height: component.height,
      component_length: component.length,
      component_min_quantity: component.min_quantity,
      component_thickness: component.thickness,
      component_weight: component.weight,
      component_width: component.width
    }

    calculator.evaluate!(formula, variables)
  rescue Dentaku::UnboundVariableError => e
    errors.add(:formula, e.message)
  rescue Dentaku::ZeroDivisionError => e
    errors.add(:formula, e.message)
  end

  private

  def add_errors_to_component_id
    # We need to add errors to the component_id attribute, to show it is as invalid on the form,
    # but i don't want to duplicate messages for the same error
    errors.add(:component_id, errors[:component].first) if errors[:component].present?
    errors.delete(:component)
  end
end
