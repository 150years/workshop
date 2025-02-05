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

  describe '#image_or_placeholder' do
    let(:component_with_image) { create(:component, :with_image) }
    let(:component_without_image) { create(:component) }
    let(:height) { 200 }
    let(:width) { 200 }

    it 'returns an image tag if image is attached' do
      expect(helper.image_or_placeholder(component_with_image.image, height, width)).to include('img')
    end

    it 'returns a skeleton div if image is not attached' do
      expect(helper.image_or_placeholder(component_without_image.image, height, width)).to include('div')
    end
  end
end
