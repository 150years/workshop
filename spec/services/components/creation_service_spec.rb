# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Components::CreationService do
  let(:company) { create(:company) }
  let(:template_component) { create(:component, company: company, name: 'Template Component') }
  let(:image) { fixture_file_upload(Rails.root.join('spec/fixtures/files/image.jpg'), 'image/jpg') }
  let(:service) { described_class.new(company, params).build }

  before do
    template_component.image.attach(image)
  end

  describe '#build' do
    context 'when template_id is provided' do
      let(:params) { { template_id: template_component.id } }

      it 'duplicates the component' do
        expect(service.component.name).to eq("#{template_component.name} (Copy)")
      end

      it 'copies the image from the original component' do
        expect(service.component.image.attached?).to be true
      end
    end

    context 'when template_id is not provided' do
      let(:params) { {} }

      it 'creates a new component' do
        expect(service.component).to be_a_new(Component)
      end
    end
  end

  describe '#save' do
    context 'when saving a component' do
      let(:params) { { template_id: template_component.id } }

      it 'assigns the company to the component' do
        service.save
        expect(service.component.company).to eq(company)
      end

      it 'saves the component successfully' do
        expect(service.save).to be_truthy
      end
    end

    context 'when attaching an image from an image_blob_id' do
      let(:blob) { ActiveStorage::Blob.create_and_upload!(io: Rails.root.join('spec/fixtures/files/image.jpg').open, filename: 'sample.jpg', content_type: 'image/jpeg') }
      let(:params) { { template_id: template_component.id, image_blob_id: blob.signed_id } }

      it 'attaches the image from blob_id' do
        service.save
        expect(service.component.image.attached?).to be true
      end
    end
  end
end
