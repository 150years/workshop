# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/clients', type: :request do
  let(:user) { create(:user) }
  let!(:client) { create(:client, company: user.company) }
  let!(:another_client) { create(:client) }

  let(:valid_attributes) do
    {
      name: 'John Doe',
      email: 'example@example.com'
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      email: 'example@'
    }
  end

  before do
    login_as user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get clients_url
      expect(response).to be_successful
    end

    it 'renders a list of clients in current organization' do
      get clients_url
      expect(response.body).to include(client.name)
      expect(response.body).not_to include(another_client.name)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get clients_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get client_url(client)
      expect(response).to be_successful
    end

    it 'renders 404 if client does not belong to current organization' do
      get client_url(another_client)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get client_url(client)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_client_url
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get new_client_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_client_url(client)
      expect(response).to be_successful
    end

    it 'renders 404 if client does not belong to current organization' do
      get edit_client_url(another_client)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get edit_client_url(client)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Client' do
        expect do
          post clients_url, params: { client: valid_attributes }
        end.to change(Client, :count).by(1)
      end

      it 'redirects to the created client' do
        post clients_url, params: { client: valid_attributes }
        expect(response).to redirect_to(client_url(Client.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Client' do
        expect do
          post clients_url, params: { client: invalid_attributes }
        end.to change(Client, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post clients_url, params: { client: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'Jane Doe'
        }
      end

      it 'updates the requested client' do
        patch client_url(client), params: { client: new_attributes }
        expect(client.reload.name).to eq('Jane Doe')
      end

      it 'redirects to the client' do
        patch client_url(client), params: { client: new_attributes }
        expect(response).to redirect_to(client_url(client))
      end

      it 'renders 404 if client does not belong to current organization' do
        patch client_url(another_client), params: { client: new_attributes }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch client_url(client), params: { client: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        patch client_url(client), params: { client: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested client' do
      expect do
        delete client_url(client)
      end.to change(Client, :count).by(-1)
    end

    it 'redirects to the clients list' do
      delete client_url(client)
      expect(response).to redirect_to(clients_url)
    end

    it 'renders 404 if client does not belong to current organization' do
      delete client_url(another_client)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        delete client_url(client)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
