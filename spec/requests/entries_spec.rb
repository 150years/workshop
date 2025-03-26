# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Entries', type: :request do
  let(:user) { create(:user) } # создаем пользователя
  before { sign_in user } # авторизуем пользователя

  describe 'GET /index' do
    it 'returns http success' do
      get '/entries/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /new' do
    it 'returns http success' do
      get '/entries/new'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/entries/create'
      expect(response).to have_http_status(:success)
    end
  end
end
