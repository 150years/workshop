# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/order_versions', type: :request do
  let(:user) { create(:user) }
  let!(:order) { create(:order, company: user.company) }
  let!(:order_version) { create(:order_version, company: user.company, order: order) }
  let(:valid_attributes) do
    {
      version_note: 'VersionNote',
      agent_comm: 15,
      profit: 10,
      final_version: false
    }
  end

  let(:invalid_attributes) do
    {
      version_note: 'VersionNote',
      agent_comm: 'Not a number',
      final_version: false
    }
  end

  before do
    sign_in user
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get order_version_url(order, order_version)
      expect(response).to be_successful
    end

    context 'when trying to access an order version from another company' do
      let(:another_order_version) { create(:order_version) }

      it 'renders 404' do
        get order_version_url(another_order_version.order, another_order_version)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        get order_version_url(order, order_version)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_order_version_url(order)
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        get new_order_version_url(order)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_order_version_url(order, order_version)
      expect(response).to be_successful
    end

    context 'when trying to edit an order version from another company' do
      let(:another_order_version) { create(:order_version) }

      it 'renders 404' do
        get edit_order_version_url(another_order_version.order, another_order_version)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        get edit_order_version_url(order, order_version)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new OrderVersion' do
        expect do
          post order_versions_url(order), params: { order_version: valid_attributes }
        end.to change(OrderVersion, :count).by(1)
      end

      it 'redirects to order' do
        post order_versions_url(order), params: { order_version: valid_attributes }
        expect(response).to redirect_to(order_url(order))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new OrderVersion' do
        expect do
          post order_versions_url(order), params: { order_version: invalid_attributes }
        end.to change(OrderVersion, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post order_versions_url(order), params: { order_version: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          version_note: 'NewVersionNote'
        }
      end

      it 'updates the requested order_version' do
        patch order_version_url(order, order_version), params: { order_version: new_attributes }
        expect(order_version.reload.version_note).to eq('NewVersionNote')
      end

      it 'redirects to the order' do
        patch order_version_url(order, order_version), params: { order_version: new_attributes }
        expect(response).to redirect_to(order_url(order))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch order_version_url(order, order_version), params: { order_version: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when trying to update an order version from another company' do
      let(:another_order_version) { create(:order_version) }

      it 'renders 404' do
        patch order_version_url(another_order_version.order, another_order_version), params: { order_version: valid_attributes }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'redirects to sign in page' do
        patch order_version_url(order, order_version), params: { order_version: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested order_version' do
      expect do
        delete order_version_url(order, order_version)
      end.to change(OrderVersion, :count).by(-1)
    end

    it 'redirects to the order' do
      delete order_version_url(order, order_version)
      expect(response).to redirect_to(order_url(order))
    end
  end
end
