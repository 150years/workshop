# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComponentsHelper, type: :helper do
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
