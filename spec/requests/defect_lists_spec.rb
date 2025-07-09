# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DefectLists', type: :request do
  let(:user) { create(:user) }
  let(:order) { create(:order) }

  before do
    sign_in user
  end
  describe 'POST /orders/:order_id/defect_list' do
    context 'when final version exists' do
      before { create(:order_version, order: order, final_version: true) }

      it 'creates a defect list and redirects' do
        expect do
          post order_defect_list_path(order)
        end.to change { DefectList.count }.by(1)

        expect(response).to redirect_to(order_defect_list_path(order))
      end
    end

    context 'when no final version' do
      it 'redirects back with alert' do
        post order_defect_list_path(order)
        expect(response).to redirect_to(order_path(order))
        follow_redirect!
        expect(response.body).to include('Please select final version of order first')
      end
    end
  end

  describe 'DELETE /orders/:order_id/defect_list' do
    let!(:defect_list) { create(:defect_list, order: order) }

    it 'destroys the defect list' do
      expect do
        delete order_defect_list_path(order)
      end.to change(DefectList, :count).by(-1)

      expect(response).to redirect_to(order_path(order))
    end
  end
end
