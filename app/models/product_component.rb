# frozen_string_literal: true

# == Schema Information
#
# Table name: product_components
#
#  id           :integer          not null, primary key
#  quantity     :integer          default(1), not null
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

  after_validation :add_errors_to_component_id

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # When product_component is created/deleted or quantity or component is changed, we need to update the price of the product
  after_create :update_product_price
  after_update :update_product_price, if: -> { saved_change_to_quantity? || saved_change_to_component_id? }
  after_destroy :update_product_price

  def update_product_price
    product.update_price
  end

  private

  def add_errors_to_component_id
    # We need to add errors to the component_id attribute, to show it is as invalid on the form,
    # but i don't want to duplicate messages for the same error
    errors.add(:component_id, errors[:component].first) if errors[:component].present?
    errors.delete(:component)
  end
end
