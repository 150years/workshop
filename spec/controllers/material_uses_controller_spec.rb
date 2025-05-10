# frozen_string_literal: true

# spec/controllers/material_uses_controller_spec.rb
require 'rails_helper'

RSpec.describe MaterialUsesController, type: :controller do
  let(:material) { Material.create!(name: 'Test', amount: 10, price: 100, code: 'SLK') }
  before do
    sign_in FactoryBot.create(:user) # или create(:admin), в зависимости от логики
  end
  it 'renders the index' do
    get :index, params: { material_id: material.id }
    expect(response).to be_successful
  end

  it 'renders the new form' do
    get :new, params: { material_id: material.id }
    expect(response).to be_successful
  end

  it 'creates a use' do
    post :create, params: { material_id: material.id, material_use: { amount: 1 } }
    expect(response).to redirect_to(materials_path)
  end
end
