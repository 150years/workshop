# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/agents', type: :request do

  describe 'GET /orders/:id/components_order_pdf' do
    let(:order) { create(:order) }
    let(:version) { create(:order_version, order:) }
    let(:component) { create(:component, category: 'glass') }
    let(:product) { create(:product, order_version: version) }

    before do
      create(:product_component, product:, component:, quantity: 2)
    end

    # it 'renders PDF for given category' do
    #   get components_order_pdf_order_path(order, category: 'glass')
    #   expect(response).to be_successful
    #   expect(response.content_type).to eq('application/pdf')
    # end

    # it 'returns 400 if category missing' do
    #   get components_order_pdf_order_path(order)
    #   expect(response.status).to eq(400)
    # end
  end
end