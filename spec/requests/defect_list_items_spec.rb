require 'rails_helper'

RSpec.describe 'DefectListItems', type: :request do
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
  end

  describe 'DELETE /orders/:order_id/defect_list/defect_list_items/:id' do
    it 'deletes defect list item' do
      expect do
        delete order_defect_list_defect_list_item_path(order, item), as: :turbo_stream
      end.to change { DefectListItem.count }.by(-1)

      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
    end
  end

  describe 'DELETE /orders/:order_id/defect_list/defect_list_items/:id/purge_photo' do
    it 'purges photo' do
      item.photos.attach(io: Rails.root.join('spec/fixtures/files/image.jpg').open, filename: 'image.jpg', content_type: 'image/jpeg')
      photo = item.photos.first

      delete purge_photo_order_defect_list_defect_list_item_path(order, item, photo_id: photo.id), as: :turbo_stream
      expect(response.media_type).to eq('text/vnd.turbo-stream.html')
      expect(item.reload.photos).to be_empty
    end
  end
end
