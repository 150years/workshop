# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#mobile_menu_button_class' do
    before do
      allow(helper).to receive(:request).and_return(double(path: current_path))
    end

    context 'when the current path includes the given path' do
      let(:current_path) { '/clients/dashboard' }

      it 'returns the btn--secondary class' do
        expect(helper.mobile_menu_button_class('/clients')).to eq('btn btn--secondary')
      end
    end

    context 'when the current path does not include the given path' do
      let(:current_path) { '/home' }

      it 'returns the btn--borderless class' do
        expect(helper.mobile_menu_button_class('/clients')).to eq('btn btn--borderless')
      end
    end
  end
end
