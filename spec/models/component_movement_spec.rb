require 'rails_helper'

RSpec.describe 'Component stock/project movement logic', type: :model do
  let(:company) { create(:company) }
  let(:component) { create(:component, company:) }
  let(:project1) { create(:order, company:, name: 'Project 1') }
  let(:project2) { create(:order, company:, name: 'Project 2') }

  it 'correctly tracks in-stock and in-project quantities' do
    # Step 1 — inbound 100
    create(:stock_movement, component:, movement_type: :inbound, quantity: 100)
    expect(component.available_stock_quantity).to eq(100)
    expect(component.quantity_in_projects).to eq(0)

    # Step 2 — to_project 60 (Project 1)
    create(:stock_movement, component:, order: project1, movement_type: :to_project, quantity: 60)
    expect(component.available_stock_quantity).to eq(40)
    expect(component.quantity_in_projects).to eq(60)

    # Step 3 — used 20 (Project 1)
    create(:stock_movement, component:, order: project1, movement_type: :used, quantity: 20)
    expect(component.available_stock_quantity).to eq(40)
    expect(component.quantity_in_projects).to eq(40)

    # Step 4 — to_project 20 (Project 2)
    create(:stock_movement, component:, order: project2, movement_type: :to_project, quantity: 20)
    expect(component.available_stock_quantity).to eq(20)
    expect(component.quantity_in_projects).to eq(60)

    # Step 5 — returned_to_stock 20 (Project 1)
    create(:stock_movement, component:, order: project1, movement_type: :returned_to_stock, quantity: 20)
    expect(component.available_stock_quantity).to eq(40)
    expect(component.quantity_in_projects).to eq(40)
  end
end
