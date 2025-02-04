# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/components', type: :request do
  let(:user) { create(:user) }
  let!(:component) { create(:component, company: user.company) }
  let!(:another_component) { create(:component) }
  let(:valid_attributes) do
    {
      code: 'MyString',
      name: 'Product name',
      note: 'This is a note',
      color: 'red 01',
      unit: 'mm',
      dimensions: '{ width: 1000 }',
      min_quantity: 1,
      price: 1
    }
  end

  let(:invalid_attributes) do
    {
      code: nil,
      color: 1,
      unit: 1,
      min_quantity: 'invalid',
      price: -1
    }
  end

  before do
    login_as user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get components_url
      expect(response).to be_successful
    end

    it 'renders a list of components in current organization' do
      get components_url
      expect(response.body).to include(component.code)
      expect(response.body).not_to include(another_component.code)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get components_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get component_url(component)
      expect(response).to be_successful
    end

    it 'renders 404 if component does not belong to current organization' do
      get component_url(another_component)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get component_url(component)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_component_url
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get new_component_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_component_url(component)
      expect(response).to be_successful
    end

    it 'renders 404 if component does not belong to current organization' do
      get edit_component_url(another_component)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get edit_component_url(component)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Component' do
        expect do
          post components_url, params: { component: valid_attributes }
        end.to change(Component, :count).by(1)
      end

      it 'redirects to the created component' do
        post components_url, params: { component: valid_attributes }
        expect(response).to redirect_to(component_url(Component.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Component' do
        expect do
          post components_url, params: { component: invalid_attributes }
        end.to change(Component, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post components_url, params: { component: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        post components_url, params: { component: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          code: 'NewString'
        }
      end

      it 'updates the requested component' do
        patch component_url(component), params: { component: new_attributes }
        expect { component.reload }.to change(component, :code).to('NewString')
      end

      it 'redirects to the component' do
        patch component_url(component), params: { component: new_attributes }
        expect(response).to redirect_to(component_url(component))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch component_url(component), params: { component: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it 'renders 404 if component does not belong to current organization' do
      patch component_url(another_component), params: { component: valid_attributes }
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        patch component_url(component), params: { component: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested component' do
      expect { delete component_url(component) }.to change(Component, :count).by(-1)
    end

    it 'redirects to the components list' do
      delete component_url(component)
      expect(response).to redirect_to(components_url)
    end

    it 'renders 404 if component does not belong to current organization' do
      delete component_url(another_component)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        delete component_url(component)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
