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
require 'rails_helper'

RSpec.describe StockMovement, type: :model do
  let(:component) { create(:component) }
  let(:project) { create(:order) }

  it 'is invalid without a component' do
    m = described_class.new(movement_type: :inbound, quantity: 10)
    expect(m).not_to be_valid
    expect(m.errors[:component]).to be_present
  end

  it 'requires quantity to be greater than 0' do
    m = described_class.new(component:, movement_type: :inbound, quantity: 0)
    expect(m).not_to be_valid
    expect(m.errors[:quantity]).to include('must be greater than 0')
  end

  it 'is invalid when used has no order' do
    m = described_class.new(component:, movement_type: :used, quantity: 10)
    expect(m).not_to be_valid
    expect(m.errors[:order]).to include('must be present for used')
  end

  it 'is invalid when returned_to_stock has no order' do
    m = described_class.new(component:, movement_type: :returned_to_stock, quantity: 10)
    expect(m).not_to be_valid
    expect(m.errors[:order]).to include('must be present for returned_to_stock')
  end
end
