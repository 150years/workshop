# frozen_string_literal: true

# spec/controllers/materials_controller_spec.rb
require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  let!(:supplier) { Supplier.create!(name: 'Supplier', contact_info: 'info') }
  let!(:material) { Material.create!(name: 'Glass', code: 'GL-001', price: 100, amount: 10, supplier:) }
  before do
    sign_in FactoryBot.create(:user) # или create(:admin), в зависимости от логики
  end
  describe 'GET #index' do
    it 'returns success' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns success' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns success' do
      get :edit, params: { id: material.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns success' do
      get :show, params: { id: material.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new material' do
      expect do
        post :create, params: {
          material: {
            name: 'Steel',
            code: 'ST-001',
            price: 200,
            amount: 5,
            supplier_id: supplier.id
          }
        }
      end.to change(Material, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    it 'updates the material' do
      patch :update, params: { id: material.id, material: { name: 'Glass' } }
      expect(material.reload.name).to eq('Glass')
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the material' do
      expect do
        delete :destroy, params: { id: material.id }
      end.to change(Material, :count).by(-1)
    end
  end
end
