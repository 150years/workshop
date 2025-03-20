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
        expect { product_component.reload }.to change { product_component.quantity.to_f }.from(1.0).to(2.0)
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
end
