# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Component stock summary logic', type: :model do
  let(:component) { create(:component) }
  let(:project1) { create(:order) }
  let(:project2) { create(:order) }

  def check(expected_stock:, expected_projects:, expected_p1:, expected_p2:)
    expect(component.available_stock_quantity).to eq(expected_stock)
    expect(component.quantity_in_projects).to eq(expected_projects)
    expect(component.available_project_quantity(project1.id)).to eq(expected_p1)
    expect(component.available_project_quantity(project2.id)).to eq(expected_p2)
  end

  it 'tracks movement accurately across warehouse and projects' do
    # 1. inbound 100
    create(:stock_movement, component:, movement_type: :inbound, quantity: 100)
    check(expected_stock: 100, expected_projects: 0, expected_p1: 0, expected_p2: 0)

    # 2. to_project 60 → Project 1
    create(:stock_movement, component:, order: project1, movement_type: :to_project, quantity: 60)
    check(expected_stock: 40, expected_projects: 60, expected_p1: 60, expected_p2: 0)

    # 3. used 20 → Project 1
    create(:stock_movement, component:, order: project1, movement_type: :used, quantity: 20)
    check(expected_stock: 40, expected_projects: 40, expected_p1: 40, expected_p2: 0)

    # 4. to_project 20 → Project 2
    create(:stock_movement, component:, order: project2, movement_type: :to_project, quantity: 20)
    check(expected_stock: 20, expected_projects: 60, expected_p1: 40, expected_p2: 20)

    # 5. returned_to_stock 20 → Project 1
    create(:stock_movement, component:, order: project1, movement_type: :returned_to_stock, quantity: 20)
    check(expected_stock: 40, expected_projects: 40, expected_p1: 20, expected_p2: 20)
  end
end
