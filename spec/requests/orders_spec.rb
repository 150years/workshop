# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/orders', type: :request do
  let(:company) { create(:company) }
  let(:user) { create(:user, company:) }
  let(:agent) { create(:agent, company:) }
  let(:client) { create(:client, company:) }

  let(:another_company) { create(:company) }
  let!(:order) { create(:order, name: "Company A Order", company:) }
  let!(:another_order) { create(:order, name: "Company B Order", company: another_company) }

  let(:valid_attributes) do
    {
      name: 'Order 1',
      client_id: client.id,
      agent_id: agent.id
    }
  end

  let(:invalid_attributes) do
    {
      client_id: nil,
      agent_id: nil
    }
  end

  before do
    sign_in user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get orders_url
      expect(response).to be_successful
    end

    it 'only returns orders from the current company' do
      get orders_url
      
      expect(response.body).to include("Company A Order")
      expect(response.body).not_to include("Company B Order")
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        get orders_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get order_url(order)
      expect(response).to be_successful
    end

    it 'displays order details' do
      get order_url(order)

      expect(response.body).to include(CGI.escapeHTML(order.name))
      expect(response.body).to include(CGI.escapeHTML(order.client.name))
      expect(response.body).to include(CGI.escapeHTML(order.agent.name))
    end

    context 'when trying to access an order from another company' do
      it 'renders 404' do
        get order_url(another_order)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        get order_url(order)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_order_url
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        get new_order_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_order_url(order)
      expect(response).to be_successful
    end

    context 'when trying to edit an order from another company' do
      it 'renders 404' do
        get edit_order_url(another_order)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        get edit_order_url(order)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Order' do
        expect do
          post orders_url, params: { order: valid_attributes }
        end.to change(Order, :count).by(1)
      end

      it 'redirects to the created order' do
        post orders_url, params: { order: valid_attributes }
        expect(response).to redirect_to(order_url(Order.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Order' do
        expect do
          post orders_url, params: { order: invalid_attributes }
        end.to change(Order, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post orders_url, params: { order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        post orders_url, params: { order: valid_attributes }
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

      it 'updates the requested order' do
        patch order_url(order), params: { order: new_attributes }

        expect(order.reload.name).to eq('New name')
      end

      it 'redirects to the order' do
        patch order_url(order), params: { order: new_attributes }
        expect(response).to redirect_to(order_url(order))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch order_url(order), params: { order: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when trying to update an order from another company' do
      it 'renders 404' do
        patch order_url(another_order), params: { order: valid_attributes }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        patch order_url(order), params: { order: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested order' do
      expect { delete order_url(order) }.to change(Order, :count).by(-1)
    end

    it 'redirects to the orders list' do
      delete order_url(order)
      expect(response).to redirect_to(orders_url)
    end

    context 'when trying to delete an order from another company' do
      it 'renders 404' do
        delete order_url(another_order)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        delete order_url(order)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
