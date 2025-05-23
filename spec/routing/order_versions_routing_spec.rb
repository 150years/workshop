# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderVersionsController, type: :routing, skip: 'TBD' do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/order_versions').to route_to('order_versions#index')
    end

    it 'routes to #new' do
      expect(get: '/order_versions/new').to route_to('order_versions#new')
    end

    it 'routes to #show' do
      expect(get: '/order_versions/1').to route_to('order_versions#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/order_versions/1/edit').to route_to('order_versions#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/order_versions').to route_to('order_versions#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/order_versions/1').to route_to('order_versions#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/order_versions/1').to route_to('order_versions#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/order_versions/1').to route_to('order_versions#destroy', id: '1')
    end
  end
end
