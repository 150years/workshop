# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Components Order Page', type: :request do
  let(:company) { create(:company) }
  let(:client) { create(:client, company:) }
  let(:agent) { create(:agent, company:) }
  let(:order) { create(:order, company:, client:, agent:) }
  let(:version) { create(:order_version, order:, company:) }

  # it 'renders components order successfully' do
  #   get components_order_order_order_version_path(order_id: order.id, id: version.id)
  #   expect(response).to have_http_status(:ok)
  #   expect(response.body).to include("Components order")
  # end

  # it 'renders with minimal layout if bare param is present' do
  #   get components_order_order_order_version_path(order_id: order.id, id: version.id, bare: 'true')
  #   expect(assigns(:minimal_layout)).to eq(true)
  # end
end
