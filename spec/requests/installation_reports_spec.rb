# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'InstallationReports', type: :request do
  let(:user) { create(:user) }
  let(:order) { create(:order) }
  let(:final_version) { create(:order_version, order: order, final_version: true) }
  let!(:product) { create(:product) }

  before do
    sign_in user
    final_version.products << product
  end

  describe 'POST /orders/:order_id/installation_report' do
    it 'creates a report if final_version exists' do
      expect do
        post order_installation_report_path(order)
      end.to change(InstallationReport, :count).by(1)
      expect(response).to redirect_to(order_installation_report_path(order))
    end

    it 'does not create report if no final_version' do
      final_version.update!(final_version: false)
      expect do
        post order_installation_report_path(order)
      end.not_to change(InstallationReport, :count)
      expect(response).to redirect_to(order_path(order))
    end
  end

  describe 'GET /orders/:order_id/installation_report' do
    include ActiveSupport::Testing::TimeHelpers
    let!(:report) { order.create_installation_report! }
    let!(:item) { report.installation_report_items.create!(product: product) }

    it 'shows the report' do
      get order_installation_report_path(order)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(product.name)
    end
  end

  describe 'DELETE /orders/:order_id/defect_list' do
    let!(:report) { order.create_installation_report! }

    it 'destroys the defect list' do
      expect do
        delete order_installation_report_path(order)
      end.to change(InstallationReport, :count).by(-1)

      expect(response).to redirect_to(order_path(order))
    end
  end
end
