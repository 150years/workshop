# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/product_components', type: :request do
  let!(:user) { create(:user) }
  let(:product) { create(:product, company: user.company) }
  let(:component) { create(:component) }
  let(:product_component) { ProductComponent.create!(product: product, component: component) }
  let(:valid_attributes) do
    {
      component_id: component.id,
      formula: 1
    }
  end

  let(:invalid_attributes) do
    {
      component_id: nil,
      formula: 'o / 0'
    }
  end

  before do
    login_as user
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_product_component_url(product)
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get new_product_component_url(product)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_product_component_url(product, product_component)
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get edit_product_component_url(product, product_component)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new ProductComponent' do
        expect do
          post product_components_url(product), params: { product_component: valid_attributes }
        end.to change(ProductComponent, :count).by(1)
      end

      it 'redirects to the product' do
        post product_components_url(product), params: { product_component: valid_attributes }
        expect(response).to redirect_to(product_url(product))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new ProductComponent' do
        expect do
          post product_components_url(product), params: { product_component: invalid_attributes }
        end.to change(ProductComponent, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post product_components_url(product), params: { product_component: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        post product_components_url(product), params: { product_component: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          formula: 2
        }
      end

      it 'updates the requested product_component' do
        patch product_component_url(product, product_component), params: { product_component: new_attributes }
        expect { product_component.reload }.to change { product_component.quantity.to_f }.to(2.0)
      end

      it 'redirects to the product' do
        patch product_component_url(product, product_component), params: { product_component: new_attributes }
        expect(response).to redirect_to(product_url(product))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch product_component_url(product, product_component), params: { product_component: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        patch product_component_url(product, product_component), params: { product_component: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    before do
      product_component
    end

    it 'destroys the requested product_component' do
      expect do
        delete product_component_url(product, product_component)
      end.to change(ProductComponent, :count).by(-1)
    end

    it 'redirects to the product' do
      delete product_component_url(product, product_component)
      expect(response).to redirect_to(product_url(product))
    end
  end

  describe 'PATCH /products/:product_id/product_components/:id/update_quantity' do
    let!(:order) { create(:order, company: user.company) }
    let!(:order_version) { create(:order_version, order: order) }
    let!(:product) { create(:product, company: user.company, order_version: order_version) }
    let!(:component) { create(:component) }
    let!(:product_component) { ProductComponent.create!(product: product, component: component) }

    it 'updates quantity_manual via the form' do
      patch "/products/#{product.id}/product_components/#{product_component.id}/update_quantity", params: {
        product_component: { quantity_manual: 1.5 }
      }

      expect(response).to redirect_to(order_path(order))
      product_component.reload
      expect(product_component.quantity_manual).to eq(1.5)
      expect(product_component.quantity).to eq(1.5)
    end
  end

  describe 'manual quantity affects total price and product price' do
    let!(:order) { create(:order, company: user.company) }
    let!(:order_version) { create(:order_version, order: order, profit: 30) } # 👈 тут 30%
    let!(:product) { create(:product, company: user.company, order_version: order_version) }
    let!(:component) { create(:component, price_cents: 100_00, category: 'aluminum') }
    let!(:product_component) { create(:product_component, product: product, component: component, quantity_manual: 2.5) }

    it 'uses quantity_manual for component and updates product total price' do
      # пересчитываем и сохраняем
      product_component.send(:set_quantity_fields)
      product_component.save!
      product.update_price
      # обновляем цену продукта вручную (или проверяем, если auto-update работает)
      product.reload

      # проверяем сумму по компоненту
      expect(product_component.quantity).to eq(2.5)
      expect((product_component.quantity * component.price.amount).round(2)).to eq(250.0)

      # базовая цена без прибыли
      base_price = product_component.quantity * component.price.amount # 2.5 * 100 = 250.0
      expected_price_cents = (base_price * 1.3 * 100).to_i # 30% profit → 32500

      expect(product.total_price_cents).to eq(expected_price_cents)
    end
  end
end
