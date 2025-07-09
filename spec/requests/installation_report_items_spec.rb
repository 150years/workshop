# frozen_string_literal: true

require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe 'InstallationReportItems', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }
  let(:order) { create(:order) }
  let(:report) { create(:installation_report, order: order) }
  let(:item) { create(:installation_report_item, installation_report: report, product: create(:product)) }

  before { sign_in user }

  it 'attaches photo' do
    file = fixture_file_upload(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg')
    patch order_installation_report_installation_report_item_path(order, item), params: {
      installation_report_item: { photos: [file] }
    }
    expect(item.reload.photos).to be_attached
  end

  describe 'PATCH /orders/:order_id/installation_report/installation_report_items/:id/edit_photo' do
    it 'replaces a specific photo via edit_photo' do
      file = fixture_file_upload(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/png')
      item.photos.attach(file)
      attachment_id = item.photos.first.id
      new_file = fixture_file_upload(Rails.root.join('spec/fixtures/files/image2.jpg'), 'image/png')
      patch edit_photo_order_installation_report_installation_report_item_path(order, item, index: 0),
            params: { photo: new_file, attachment_id: attachment_id }

      expect(response).to have_http_status(:ok).or have_http_status(:success)
      expect(item.reload.photos.count).to eq(1)
      expect(item.photos.first.filename.to_s).to eq('marked.png')
    end
  end

  it 'purges photo' do
    file = fixture_file_upload(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg')
    item.photos.attach(file)
    blob_id = item.photos.first.signed_id

    delete purge_photo_order_installation_report_installation_report_item_path(order, item, blob_id: blob_id)
    expect(item.reload.photos).to be_empty
  end

  it 'updates updated_at on parent installation_report' do
    original_time = item.installation_report.updated_at

    travel 1.minute do
      patch order_installation_report_installation_report_item_path(order, item),
            params: { installation_report_item: { comment: 'new comment' }, index: 0 }

      expect(item.installation_report.reload.updated_at).to be > original_time
    end
  end
end
