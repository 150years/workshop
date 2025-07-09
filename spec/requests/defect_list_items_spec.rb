# frozen_string_literal: true

require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe 'DefectListItems', type: :request do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create(:user) }
  let(:order) { create(:order) }
  let(:defect_list) { create(:defect_list, order: order) }
  let(:product) { create(:product) }
  let!(:item) { create(:defect_list_item, defect_list: defect_list, product: product) }

  before { sign_in user }

  describe 'POST /orders/:order_id/defect_list/defect_list_items' do
    it 'creates defect list item' do
      expect do
        post order_defect_list_defect_list_items_path(order), params: { product_id: product.id }, as: :turbo_stream
      end.to change { DefectListItem.count }.by(1)

      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end
  end

  describe 'PATCH /orders/:order_id/defect_list/defect_list_items/:id' do
    it 'updates defect list item' do
      patch order_defect_list_defect_list_item_path(order, item),
            params: { defect_list_item: { comment: 'Updated comment' } }, as: :turbo_stream

      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      expect(item.reload.comment).to eq('Updated comment')
    end

    it 'updates updated_at on parent installation_report' do
      original_time = item.defect_list.updated_at

      travel 1.minute do
        patch order_defect_list_defect_list_item_path(order, item),
              params: { defect_list_item: { comment: 'new comment' }, index: 0 }

        expect(item.defect_list.reload.updated_at).to be > original_time
      end
    end
  end

  describe 'DELETE /orders/:order_id/defect_list/defect_list_items/:id' do
    it 'deletes defect list item' do
      expect do
        delete order_defect_list_defect_list_item_path(order, item), as: :turbo_stream
      end.to change { DefectListItem.count }.by(-1)

      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end
  end

  describe 'PATCH /orders/:order_id/defect_list/defect_list_items/:id with photo_before and photo_after' do
    let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg') }

    it 'attaches photo_before' do
      expect do
        patch order_defect_list_defect_list_item_path(order, item),
              params: { defect_list_item: { photo_before: file } }, as: :turbo_stream
      end.to change { item.reload.photo_before.attached? }.from(false).to(true)
    end

    it 'attaches photo_after' do
      expect do
        patch order_defect_list_defect_list_item_path(order, item),
              params: { defect_list_item: { photo_after: file } }, as: :turbo_stream
      end.to change { item.reload.photo_after.attached? }.from(false).to(true)
    end
  end

  describe 'PATCH /orders/:order_id/defect_list/defect_list_items/:id/edit_photo' do
    it 'attaches photo_before via edit_photo' do
      file = fixture_file_upload(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/png')

      patch edit_photo_order_defect_list_defect_list_item_path(order, item, field: 'photo_before'),
            params: { defect_list_item: { photo_before: file } }

      expect(response).to have_http_status(:success).or have_http_status(:ok)
      expect(item.reload.photo_before).to be_attached
    end
  end

  describe 'DELETE purge_photo for specific attachment' do
    let(:file) { fixture_file_upload(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpeg') }

    before do
      item.photo_before.attach(file)
      item.photo_after.attach(file)
    end

    it 'purges photo_before' do
      delete purge_photo_order_defect_list_defect_list_item_path(order, item, which: 'before'), as: :turbo_stream
      expect(item.reload.photo_before.attached?).to be false
    end

    it 'purges photo_after' do
      delete purge_photo_order_defect_list_defect_list_item_path(order, item, which: 'after'), as: :turbo_stream
      expect(item.reload.photo_after.attached?).to be false
    end
  end
end
