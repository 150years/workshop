# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  comment    :string
#  height     :integer          default(0), not null
#  name       :string           not null
#  width      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
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
