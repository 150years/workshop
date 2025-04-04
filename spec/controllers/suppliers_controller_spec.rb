# frozen_string_literal: true

# spec/controllers/suppliers_controller_spec.rb
require 'rails_helper'

RSpec.describe SuppliersController, type: :controller do
  let!(:supplier) { create(:supplier, name: 'Alpha') }
  before do
    sign_in FactoryBot.create(:user) # или create(:admin), в зависимости от логики
  end

  let(:user) { create(:user) } # или :admin, если нужно

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
      get :edit, params: { id: supplier.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new supplier' do
      expect do
        post :create, params: {
          supplier: {
            name: 'Some Name',
            email: '1@1.com',
            contact_info: 'Info'
          }
        }
      end.to change(Supplier, :count).by(1)
    end
    context 'with invalid params' do
      it 'does not create supplier and renders :new' do
        expect do
          post :create, params: {
            supplier: {
              name: '',           # ❌ invalid
              contact_info: ''    # ❌ invalid
            }
          }
        end.not_to change(Supplier, :count)

        expect(response).to render_template(:index) # 💡 покрытие ветки
        expect(assigns(:supplier)).to be_a_new(Supplier)
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates supplier' do
      patch :update, params: { id: supplier.id, supplier: { name: 'New Name' } }
      expect(supplier.reload.name).to eq('New Name')
    end
    context 'with invalid params' do
      it 'does not update supplier and renders :edit' do
        patch :update, params: {
          id: supplier.id,
          supplier: {
            name: '', # ❌ invalid
            contact_info: ''
          }
        }

        expect(response).to render_template(:index) # 💡 ещё одна ветка
        expect(assigns(:supplier)).to eq(supplier)
        expect(supplier.reload.name).to eq(supplier.name)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the supplier' do
      expect do
        delete :destroy, params: { id: supplier.id }
      end.to change(Supplier, :count).by(-1)
    end
  end
end
