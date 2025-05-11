# frozen_string_literal: true

# spec/controllers/materials_controller_spec.rb
require 'rails_helper'

RSpec.describe MaterialsController, type: :controller do
  let!(:supplier) { create(:supplier) }
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

    context 'with invalid params' do
      it 'does not create a material and renders :new' do
        post :create, params: {
          material: {
            name: '', # ❌ invalid
            code: '',
            price: nil,
            amount: -1,
            supplier_id: nil
          }
        }

        expect(response).to render_template(:new) # 💡 Это покрывает else
        expect(assigns(:material)).to be_a_new(Material)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:material) { Material.create!(name: 'Steel', code: 'ST-001', price: 100, amount: 10, supplier: supplier) }

    context 'with invalid params' do
      it 'does not update material and renders :edit' do
        patch :update, params: {
          id: material.id,
          material: {
            name: '', # ❌ invalid
            code: '',
            price: nil,
            amount: -10,
            supplier_id: nil
          }
        }

        expect(response).to render_template(:index) # 💡 Ещё одна важная ветка
        expect(assigns(:material)).to eq(material)
      end
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
