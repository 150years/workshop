# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  comment          :string
#  height           :integer          default(0), not null
#  name             :string           not null
#  price_cents      :integer          default(0), not null
#  quantity         :integer
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

  describe 'delegations' do
    it { should delegate_method(:currency).to(:company) }
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

  describe 'callbacks' do
    describe '#copy_template' do
      it 'calls copy_template if created from template' do
        product = build(:product, from_template: true)

        expect(product).to receive(:copy_template)

        product.valid?
      end
    end

    describe '#update_order_version_total_amount' do
      it 'calls update_order_version_total_amount after destroy if it has order version' do
        product = create(:product, order_version: create(:order_version))

        expect(product).to receive(:update_order_version_total_amount)

        product.destroy
      end

      it 'does not call update_order_version_total_amount after destroy if it does not have order version' do
        product = create(:product)

        expect(product).not_to receive(:update_order_version_total_amount)

        product.destroy
      end
    end

    describe '#recalculate_product_components_amount' do
      it 'calls recalculate_product_components_amount if width or height changed' do
        product = create(:product)

        expect(product).to receive(:recalculate_product_components_amount)

        product.update(width: 10)

        expect(product).to receive(:recalculate_product_components_amount)

        product.update(height: 10)
      end

      it 'does not call recalculate_product_components_amount if width or height did not change' do
        product = create(:product)

        expect(product).not_to receive(:recalculate_product_components_amount)

        product.update(name: 'New name')
      end
    end

    describe '#update_order_version_total_amount' do
      it 'calls update_order_version_total_amount after save if price changed' do
        product = create(:product, order_version: create(:order_version))

        expect(product).to receive(:update_order_version_total_amount)

        product.update(price_cents: 100)
      end

      it 'does not call update_order_version_total_amount after save if price did not change' do
        product = create(:product, order_version: create(:order_version))

        expect(product).not_to receive(:update_order_version_total_amount)

        product.update(name: 'New name')
      end

      it 'does not call update_order_version_total_amount after save if it does not have order version' do
        product = create(:product)

        expect(product).not_to receive(:update_order_version_total_amount)

        product.update(price_cents: 100)
      end
    end
  end

  describe 'scopes' do
    describe '.templates' do
      it 'returns only products without order version' do
        create(:product, order_version: create(:order_version)) # Product with order version
        template = create(:product, order_version: nil)

        expect(Product.templates).to match_array([template])
      end
    end
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

  describe '#update_price' do
    let(:product) { create(:product) }
    let(:component1) { create(:component, price_cents: 100) }
    let(:component2) { create(:component, price_cents: 200) }

    before do
      create(:product_component, product: product, component: component1)
      create(:product_component, product: product, component: component2)

      # We need to update quantity of components without triggering callbacks
      product.product_components.update_all(quantity: 2) # rubocop:disable Rails/SkipsModelValidations
    end

    it 'updates the product price' do
      expect { product.update_price }.to change { product.price_cents }.to(600)
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
      expect(product.area_ft2).to eq(0.0054)
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

  describe '#recalculate_product_components_amount' do
    let(:product) { create(:product, width: 1000, height: 1000) }
    let!(:product_component1) { create(:product_component, product: product, formula: 'product_width') }
    let!(:product_component2) { create(:product_component, product: product, formula: 'product_height') }

    it 'updates the quantity of each product component' do
      expect { product.reload.update(width: 7000, height: 8000) }
        .to change { product_component1.reload.quantity }
        .from(1000).to(7000)
        .and change { product_component2.reload.quantity }
        .from(1000).to(8000)
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

    context 'when template does not exist' do
      let(:product) { Product.new(company: create(:company)) }
      it 'adds an error' do
        expect(product.errors[:template_id]).to include('not found')
      end
    end
  end

  describe '#update_price' do
    it 'updates price according to component quantity and product quantity' do
      product = create(:product, quantity: 2, width: 100, height: 100)
      component = create(:component, price_cents: 200, min_quantity: 1)
      create(:product_component, product: product, component: component, formula: nil)

      product.reload.update_price

      # product.product_components.includes(:component).find_each do |pc|
      #   puts "Component: #{pc.component.name}, Price: #{pc.component.price_cents}, Qty: #{pc.quantity}, Qty Real: #{pc.quantity_real}, Formula: #{pc.formula.inspect}"
      # end

      # puts "Product quantity: #{product.quantity}, Final price_cents: #{product.price_cents}"

      expect(product.price_cents).to eq(200 * 1 * 2) # min_quantity = 1, product qty = 2
    end
  end
end
