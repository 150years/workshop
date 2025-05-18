# frozen_string_literal: true

# == Schema Information
#
# Table name: stock_movements
#
#  id            :integer          not null, primary key
#  comment       :text
#  movement_type :integer          not null
#  quantity      :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  component_id  :integer          not null
#  order_id      :integer
#  user_id       :integer
#
# Indexes
#
#  index_stock_movements_on_component_id  (component_id)
#  index_stock_movements_on_order_id      (order_id)
#  index_stock_movements_on_user_id       (user_id)
#
# Foreign Keys
#
#  component_id  (component_id => components.id)
#  order_id      (order_id => orders.id)
#  user_id       (user_id => users.id)
#
FactoryBot.define do
  factory :stock_movement do
    component { nil }
    order { nil }
    user { nil }
    quantity { 1 }
    movement_type { 1 }
    comment { 'MyText' }
  end
end
