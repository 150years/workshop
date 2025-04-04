# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Components Order PDF', type: :request do
  let(:company) { create(:company) }
  let(:client) { create(:client, company:) }
  let(:agent) { create(:agent, company:) }
  let(:order) { create(:order, company:, client:, agent:) }
  let(:version) { create(:order_version, order:, company:) }

  let(:supplier) { create(:supplier, name: 'GlassCo') }
  let(:component) { create(:component, category: 'glass', supplier:) }

  before do
    product = create(:product, order_version: version)
    create(:product_component, product:, component:, quantity: 4)
  end

  it 'returns PDF for given category and supplier' do
    get components_order_order_path(order.id, category: 'glass', supplier_id: supplier.id)
    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/pdf')
  end

  #   it 'returns 400 if category or supplier missing' do
  #     get components_order_pdf_order_path(order.id)
  #     expect(response.status).to eq(400)
  #   end
end
