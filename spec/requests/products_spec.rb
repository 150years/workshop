# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/products', type: :request do
  let(:user) { create(:user) }
  let!(:product) { create(:product, company: user.company) }
  let(:valid_attributes) do
    {
      name: 'Product name',
      width: 1,
      height: 1,
      comment: 'This is a comment'
    }
  end

  let(:invalid_attributes) do
    {
      name: nil,
      width: 'invalid',
      height: 'invalid',
      comment: nil
    }
  end

  before do
    login_as user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get products_url
      expect(response).to be_successful
    end

    it 'renders a list of products' do
      get products_url
      expect(response.body).to include(CGI.escapeHTML(product.name))
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get products_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get product_url(product)
      expect(response).to be_successful
    end

    context 'with order version' do
      let!(:product) { create(:product, :with_order_version, company: user.company) }

      it 'renders a successful response' do
        get product_url(product)
        expect(response).to be_successful
      end
    end

    describe 'components categories' do
      let(:component1) { create(:component, name: 'component 1 name', company: user.company, category: :aluminum) }
      let(:component2) { create(:component, name: 'component 2 name', company: user.company, category: :glass) }
      let(:component3) { create(:component, name: 'component 3 name', company: user.company, category: :other) }

      before do
        create(:product_component, product: product, component: component1)
        create(:product_component, product: product, component: component2)
        create(:product_component, product: product, component: component3)
      end

      it 'renders components in all categories' do
        get product_url(product)
        expect(response.body).to include(component1.name)
        expect(response.body).to include(component2.name)
        expect(response.body).to include(component3.name)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get product_url(product)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_product_url
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get new_product_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_product_url(product)
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get edit_product_url(product)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Product' do
        expect do
          post products_url, params: { product: valid_attributes }
        end.to change(Product, :count).by(1)
      end

      it 'redirects to the created product' do
        post products_url, params: { product: valid_attributes }
        expect(response).to redirect_to(product_url(Product.last))
      end
    end

    context 'with order version' do
      let(:order_version) { create(:order_version, company: user.company) }

      it 'creates a new Product' do
        expect do
          post products_url, params: { product: valid_attributes, order_version_id: order_version.id }
        end.to change(Product, :count).by(1)
      end

      it 'renders turbo response to update order version' do
        post products_url, params: { product: valid_attributes, order_version_id: order_version.id }

        expect(response.body).to include('turbo-stream')
        expect(response.body).to include("order_version_#{order_version.id}")
        expect(response.body).to include(order_version.id.to_s)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Product' do
        expect do
          post products_url, params: { product: invalid_attributes }
        end.to change(Product, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post products_url, params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        post products_url, params: { product: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'New name'
        }
      end

      it 'updates the requested product' do
        patch product_url(product), params: { product: new_attributes }
        expect { product.reload }.to change(product, :name).to('New name')
      end

      it 'redirects to the product' do
        patch product_url(product), params: { product: new_attributes }
        expect(response).to redirect_to(product_url(product))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch product_url(product), params: { product: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        patch product_url(product), params: { product: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested product' do
      expect { delete product_url(product) }.to change(Product, :count).by(-1)
    end

    it 'redirects to the products list' do
      delete product_url(product)
      expect(response).to redirect_to(products_url)
    end

    context 'with order version' do
      let(:order_version) { create(:order_version, company: user.company) }
      let!(:product) { create(:product, company: user.company, order_version: order_version) }

      it 'renders turbo response to update order version' do
        delete product_url(product)

        expect(response.body).to include('turbo-stream')
        expect(response.body).to include("order_version_#{order_version.id}")
        expect(response.body).to include(order_version.id.to_s)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        delete product_url(product)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
