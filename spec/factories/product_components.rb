# frozen_string_literal: true

# == Schema Information
#
# Table name: product_components
#
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
FactoryBot.define do
  factory :product_component do
    product
    component
    quantity { 1 }
  end
end
