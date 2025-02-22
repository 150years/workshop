# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  comment          :string
#  height           :integer          default(0), not null
#  name             :string           not null
#  width            :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :integer          not null
#  order_version_id :integer
#
# Indexes
#
#  index_products_on_company_id        (company_id)
#  index_products_on_order_version_id  (order_version_id)
#
# Foreign Keys
#
#  company_id        (company_id => companies.id)
#  order_version_id  (order_version_id => order_versions.id)
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:order_version).optional }
    it { should have_many(:product_components).dependent(:destroy) }
  end

  describe 'active storage' do
    it { should have_one_attached(:image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:width) }
    it { should validate_presence_of(:height) }
    it { should validate_numericality_of(:width).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:height).is_greater_than_or_equal_to(0) }
  end

  describe '#area' do
    it 'returns the product area' do
      product = Product.new(width: 5, height: 10)
      expect(product.area).to eq(50)
    end
  end

  describe '#perimeter' do
    it 'returns the product perimeter' do
      product = Product.new(width: 5, height: 10)
      expect(product.perimeter).to eq(30)
    end
  end
end
