# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/agents', type: :request do
  let(:user) { create(:user) }
  let!(:agent) { create(:agent, company: user.company) }
  let!(:another_agent) { create(:agent) }
  let(:valid_attributes) do
    {
      name: 'Agent Name'
    }
  end

  let(:invalid_attributes) do
    {
      name: ''
    }
  end

  before do
    login_as user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      get agents_url
      expect(response).to be_successful
    end

    it 'renders a list of agents in current organization' do
      get agents_url
      expect(response.body).to include(CGI.escapeHTML(agent.name))
      expect(response.body).not_to include(CGI.escapeHTML(another_agent.name))
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get agents_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      get agent_url(agent)
      expect(response).to be_successful
    end

    it 'renders 404 if agent does not belong to current organization' do
      get agent_url(another_agent)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get agent_url(agent)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_agent_url
      expect(response).to be_successful
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get new_agent_url
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      get edit_agent_url(agent)
      expect(response).to be_successful
    end

    it 'renders 404 if agent does not belong to current organization' do
      get edit_agent_url(another_agent)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        get edit_agent_url(agent)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Agent' do
        expect do
          post agents_url, params: { agent: valid_attributes }
        end.to change(Agent, :count).by(1)
      end

      it 'redirects to the created agent' do
        post agents_url, params: { agent: valid_attributes }
        expect(response).to redirect_to(agent_url(Agent.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Agent' do
        expect do
          post agents_url, params: { agent: invalid_attributes }
        end.to change(Agent, :count).by(0)
      end

      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post agents_url, params: { agent: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        post agents_url, params: { agent: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'New Agent Name'
        }
      end

      it 'updates the requested agent' do
        patch agent_url(agent), params: { agent: new_attributes }
        expect(agent.reload.name).to eq('New Agent Name')
      end

      it 'redirects to the agent' do
        patch agent_url(agent), params: { agent: new_attributes }
        expect(response).to redirect_to(agent_url(agent))
      end
    end

    context 'with invalid parameters' do
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        patch agent_url(agent), params: { agent: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    it 'renders 404 if agent does not belong to current organization' do
      patch agent_url(another_agent), params: { agent: valid_attributes }
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        patch agent_url(agent), params: { agent: valid_attributes }
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested agent' do
      expect do
        delete agent_url(agent)
      end.to change(Agent, :count).by(-1)
    end

    it 'redirects to the agents list' do
      delete agent_url(agent)
      expect(response).to redirect_to(agents_url)
    end

    it 'renders 404 if agent does not belong to current organization' do
      delete agent_url(another_agent)
      expect(response).to have_http_status(:not_found)
    end

    context 'when user is not logged in' do
      before do
        logout
      end

      it 'redirects to sign in page' do
        delete agent_url(agent)
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end
end
