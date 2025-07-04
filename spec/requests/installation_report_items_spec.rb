# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'InstallationReportItems', type: :request do
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

  it 'purges photo' do
    file = fixture_file_upload(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg')
    item.photos.attach(file)
    blob_id = item.photos.first.signed_id

    delete purge_photo_order_installation_report_installation_report_item_path(order, item, blob_id: blob_id)
    expect(item.reload.photos).to be_empty
  end
end
