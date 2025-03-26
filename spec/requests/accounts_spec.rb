# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Accounts', type: :request do
  let(:user) { create(:user) } # создаем пользователя
  before { sign_in user } # авторизуем пользователя

  describe 'GET /index' do
    it 'returns http success' do
      get accounts_path
      expect(response).to have_http_status(:success) # Проверка успешного ответа
    end
  end
end
