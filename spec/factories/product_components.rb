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
FactoryBot.define do
  factory :product_component do
    product
    component
    quantity { 1.0 }
  end
end
