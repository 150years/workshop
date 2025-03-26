# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  category     :integer          default("aluminum"), not null
#  code         :string           not null
#  color        :string
#  height       :decimal(7, 1)
#  length       :decimal(7, 1)
#  min_quantity :decimal(7, 1)
#  name         :string           not null
#  note         :string
#  price_cents  :integer          default(0), not null
#  thickness    :decimal(7, 1)
#  unit         :integer          not null
#  weight       :decimal(7, 1)
#  width        :decimal(7, 1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer
#
# Indexes
#
#  index_components_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Component, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:company).optional }
    it { is_expected.to have_many(:product_components).dependent(:restrict_with_error) }
    it { is_expected.to have_many(:products).through(:product_components) }
  end

  describe 'active storage' do
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:unit).with_values(mm: 0, pc: 1, lot: 2, m: 3, m2: 4, kg: 5, lines: 6).with_prefix }
    it { is_expected.to define_enum_for(:category).with_values(aluminum: 0, glass: 1, other: 2) }
  end

  describe 'delegations' do
    it { should delegate_method(:currency).to(:company) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:unit) }
    it { is_expected.to validate_presence_of(:min_quantity) }
    it { is_expected.to validate_presence_of(:category) }

    it { is_expected.to validate_numericality_of(:length).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:width).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:height).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:thickness).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:weight).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:min_quantity).is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    describe '#update_products_total_amount' do
      let!(:product_component) { create(:product_component, formula: '1') }
      let(:product) { product_component.product }
      let(:component) { product_component.component }
      it 'updates the price of the related products if price changed' do
        component.reload

        expect { component.update(price_cents: 500_000) }.to change { product.reload.price_cents }.to(500_000)
      end
    end
  end

  describe '#area' do
    it 'returns the area of the component' do
      component = build(:component, width: 10, length: 10)
      expect(component.area).to eq(100)
    end
  end

  describe '#perimeter' do
    it 'returns the perimeter of the component' do
      component = build(:component, width: 10, length: 10)
      expect(component.perimeter).to eq(40)
    end
  end
end
