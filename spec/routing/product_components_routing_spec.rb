# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductComponentsController, type: :routing, skip: 'not yet implemented' do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/product_components').to route_to('product_components#index')
    end

    it 'routes to #new' do
      expect(get: '/product_components/new').to route_to('product_components#new')
    end

    it 'routes to #show' do
      expect(get: '/product_components/1').to route_to('product_components#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/product_components/1/edit').to route_to('product_components#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/product_components').to route_to('product_components#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/product_components/1').to route_to('product_components#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/product_components/1').to route_to('product_components#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/product_components/1').to route_to('product_components#destroy', id: '1')
    end
  end
end
