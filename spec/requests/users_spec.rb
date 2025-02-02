# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/users', type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  let(:valid_attributes) do
    {
      name: 'John Doe',
      email: 'test@example.com',
      password: 'password'
    }
  end

  let(:invalid_attributes) do
    {
      name: '',
      email: 'test@',
      password: '1'
    }
  end

  before do
    login_as user
  end

  describe 'GET /index' do
    before do
      another_user
    end

    it 'renders a successful response' do
      get users_url
      expect(response).to be_successful
    end

    it 'renders a list of users in current organization' do
      get users_url
      expect(response.body).to include(user.name)
      expect(response.body).not_to include(another_user.name)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get users_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get user_url(user)
      expect(response).to be_successful
    end

    it "renders a 404 error when user doesn't belong to current organization" do
      get user_url(another_user)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get user_url(user)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_user_url
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get new_user_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_user_url(user)
      expect(response).to be_successful
    end

    it "renders a 404 error when user doesn't belong to current organization" do
      get edit_user_url(another_user)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get edit_user_url(user)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url, params: { user: invalid_attributes }
        end.to change(User, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post users_url, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PATCH /update' do
    let(:valid_params) { { user: { name: 'New Name', email: 'new@example.com', password: } } }
    let(:password) { '' }

    context 'when updating only name and email (without password)' do
      it 'updates the user without changing the password' do
        expect { patch user_path(user), params: valid_params }.to change { user.reload.name }.to('New Name')
                                                                                             .and change { user.reload.email }.to('new@example.com')

        expect { patch user_path(user), params: valid_params }.not_to(change { user.reload.encrypted_password }) # Password should not change

        expect(response).to redirect_to(user)
        expect(flash[:notice]).to eq('User was successfully updated.')
      end
    end

    context 'when updating password' do
      let(:password) { 'new_password' }

      it 'updates the user with new password' do
        expect { patch user_path(user), params: valid_params }.to(change { user.reload.encrypted_password })
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch user_url(user), params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        patch user_url(user), params: { user: valid_params }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested user' do
      expect do
        delete user_url(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users list' do
      delete user_url(user)
      expect(response).to redirect_to(users_url)
    end

    it "renders a 404 error when user doesn't belong to current organization" do
      delete user_url(another_user)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        delete user_url(user)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
