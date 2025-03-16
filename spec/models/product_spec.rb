# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  comment          :string
#  height           :integer          default(0), not null
#  name             :string           not null
#  price            :integer          default(0), not null
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
  describe 'attributes' do
    it { should respond_to(:from_template) }
    it { should respond_to(:template_id) }
  end

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:order_version).optional }
    it { should have_many(:product_components).dependent(:destroy) }
    it { should have_many(:components).through(:product_components) }
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

  describe 'self.with_only_components(*component_ids)' do
    let(:component1) { create(:component) }
    let(:component2) { create(:component) }
    let(:product1) { create(:product) }
    let(:product2) { create(:product) }
    let(:product3) { create(:product) }
    let(:product4) { create(:product) }

    before do
      create(:product_component, product: product1, component: component1)
      create(:product_component, product: product1, component: component2)
      create(:product_component, product: product2, component: component1)
      create(:product_component, product: product3, component: component1)
      create(:product_component, product: product4, component: component2)
    end

    it 'returns products with only the specified components' do
      expect(Product.with_only_components(component1.id)).to match_array([product1, product2, product3])
    end
  end

  describe '#copy_template' do
    let(:product) { Product.new(company: template.company) }
    let(:template) { create(:product, :with_image) }
    let!(:product_component) { create(:product_component, product: template) }

    before do
      product.from_template = true
      product.template_id = template.id
      product.save
    end

    it 'copies the product attributes' do
      expect(product.name).to eq(template.name)
      expect(product.comment).to eq(template.comment)
    end

    it "copies the product's image" do
      expect(product.image).to be_attached
    end

    it 'copies the product components' do
      expect(product.product_components.first.component).to eq(product_component.component)
    end
  end

  describe '#area' do
    it 'returns the product area' do
      product = Product.new(width: 5, height: 10)
      expect(product.area).to eq(50)
    end
  end

  describe '#area_ft2' do
    it 'returns the product area in ft2' do
      product = Product.new(width: 50, height: 10)
      expect(product.area_ft2).to eq(0.00538195)
    end
  end

  describe '#area_m2' do
    it 'returns the product area in m2' do
      product = Product.new(width: 50, height: 10)
      expect(product.area_m2).to eq(0.0005)
    end
  end

  describe '#perimeter' do
    it 'returns the product perimeter' do
      product = Product.new(width: 5, height: 10)
      expect(product.perimeter).to eq(30)
    end
  end
end
