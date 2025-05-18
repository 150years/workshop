# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StockMovement, type: :model do
  let(:component) { create(:component) }
  let(:project) { create(:order) }

  before do
    # Стартовый приход на склад
    create(:stock_movement, component:, movement_type: :inbound, quantity: 100)
    # Списание 60 на проект
    create(:stock_movement, component:, order: project, movement_type: :to_project, quantity: 60)
    # Использовано 20
    create(:stock_movement, component:, order: project, movement_type: :used, quantity: 20)
  end

  it 'disallows to_project movement exceeding stock' do
    movement = StockMovement.new(component:, order: project, movement_type: :to_project, quantity: 1000)
    expect(movement).to be_invalid
    expect(movement.errors[:quantity]).to include(/exceeds available stock/i)
  end

  it 'disallows used movement exceeding project quantity' do
    # Сейчас на проекте 40
    movement = StockMovement.new(component:, order: project, movement_type: :used, quantity: 50)
    expect(movement).to be_invalid
    expect(movement.errors[:quantity]).to include(/exceeds available quantity on project/i)
  end

  it 'disallows returned_to_stock exceeding project quantity' do
    # Сейчас на проекте 40
    movement = StockMovement.new(component:, order: project, movement_type: :returned_to_stock, quantity: 50)
    expect(movement).to be_invalid
    expect(movement.errors[:quantity]).to include(/exceeds available quantity on project/i)
  end
end
