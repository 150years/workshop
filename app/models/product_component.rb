# frozen_string_literal: true

# == Schema Information
#
# Table name: product_components
#
#  id              :integer          not null, primary key
#  formula         :string
#  quantity        :decimal(7, 1)    default(0.0), not null
#  quantity_manual :decimal(, )
#  quantity_real   :decimal(7, 1)    default(0.0), not null
#  ratio           :decimal(3, 2)    default(0.0)
#  waste           :decimal(7, 1)    default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  component_id    :integer          not null
#  product_id      :integer          not null
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
  CALCULATION_VARIABLES = {
    product_height: ->(pc) { UnitConverter.mm_to_m(pc.product.height) },
    product_width: ->(pc) { UnitConverter.mm_to_m(pc.product.width) },
    product_area: ->(pc) { UnitConverter.mm2_to_m2(pc.product.area) },
    product_perimeter: ->(pc) { UnitConverter.mm_to_m(pc.product.perimeter) },
    component_height: ->(pc) { UnitConverter.mm_to_m(pc.component.height) },
    component_length: ->(pc) { UnitConverter.mm_to_m(pc.component.length) },
    component_min_quantity: ->(pc) { pc.component.min_quantity },
    component_thickness: ->(pc) { pc.component.thickness },
    component_weight: ->(pc) { pc.component.weight },
    component_width: ->(pc) { UnitConverter.mm_to_m(pc.component.width) }
  }.freeze

  belongs_to :product
  belongs_to :component

  validates :quantity, :quantity_real, :ratio, :waste, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :quantity_manual_cannot_be_less_than_real

  after_validation :add_errors_to_component_id
  after_validation :calculate_quantity_real, if: -> { component_id.present? }
  before_save :set_quantity_fields
  after_create :update_product_price
  after_update :update_product_price, if: -> { saved_change_to_quantity? || saved_change_to_component_id? }
  after_destroy :update_product_price

  def self.ransackable_attributes(_auth_object = nil)
    %w[id component_id product_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[products]
  end

  def set_quantity_fields
    self.quantity_real = calculate_quantity_real
    self.quantity = calculate_quantity
    self.waste = calculate_waste
    self.ratio = calculate_ratio

    # We need to reset it to recalculate it if something else changes before save
    @calculated_quantity_real = nil
  end

  def update_product_price
    product.update_price
  end

  private

  def calculate_quantity_real
    # return component.min_quantity if formula.blank?
    # If the quantity is already calculated during validation, we don't need to calculate it again
    return 1 if formula.blank? # 👈 значение по умолчанию
    return @calculated_quantity_real if defined?(@calculated_quantity_real) && @calculated_quantity_real.present?

    @calculated_quantity_real = evaluate_quantity
  rescue Dentaku::ParseError, Dentaku::UnboundVariableError, Dentaku::ZeroDivisionError, Dentaku::ArgumentError => e
    errors.add(:formula, e.message)
  end

  def calculate_quantity
    return quantity_manual.to_f if quantity_manual.present?

    quantity = formula.blank? ? 1 : evaluate_quantity.to_f

    if component.min_quantity.to_f.positive?
      min_qty = component.min_quantity.to_f
      quantity = (quantity / min_qty).ceil * min_qty
    end

    quantity
  rescue Dentaku::ParseError,
         Dentaku::UnboundVariableError,
         Dentaku::ZeroDivisionError,
         Dentaku::ArgumentError => e

    errors.add(:formula, e.message)
    # 1
  end

  def calculate_waste
    # Waste is calculated as the difference between the quantity and the real quantity
    return 0 if quantity_real.blank? || quantity_real.zero? || quantity.blank? || quantity.zero?

    quantity - quantity_real
  end

  def calculate_ratio
    return 0 if quantity_real.blank? || quantity_real.zero? || quantity.blank? || quantity.zero?

    quantity_real / quantity
  end

  def evaluate_quantity
    Dentaku::Calculator.new.evaluate!(formula, calculation_variables)
  end

  def calculation_variables
    # We need to transform the variables to their actual values
    CALCULATION_VARIABLES.transform_values { |proc| proc.call(self) }
  end

  def quantity_manual_cannot_be_less_than_real
    return if quantity_manual.blank? || quantity_real.blank?

    return unless quantity_manual < quantity_real

    errors.add(:quantity_manual, "cannot be less than calculated real quantity (#{quantity_real})")
  end

  def add_errors_to_component_id
    # We need to add errors to the component_id attribute, to show it is as invalid on the form,
    # but i don't want to duplicate messages for the same error
    errors.add(:component_id, errors[:component].first) if errors[:component].present?
    errors.delete(:component)
  end
end
