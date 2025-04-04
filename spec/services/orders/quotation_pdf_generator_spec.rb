# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Orders::QuotationPdfGenerator, type: :service do
  let(:company) { create(:company) }
  let(:client) { create(:client, company:) }
  let(:agent) { create(:agent, company:) }
  let(:order) { create(:order, company:, client:, agent:) }
  let(:version) { create(:order_version, order:, company:, total_amount_cents: 10_000) }
  let!(:labor_component) { create(:component, name: 'Labor', price: 1000, company:) }
  let!(:product) { create(:product, order_version: version) }
  let!(:product_component) do
    create(:product_component, product:, component: labor_component, quantity: 2)
  end

  before do
    version.update(discount_cents: 500)
  end
  subject(:service) { described_class.new(order, version) }

  describe Orders::QuotationPdfGenerator do
    let(:order) { create(:order_with_final_version) } # твоя фабрика
    let(:version) { order.order_versions.last }

    it 'renders pdf successfully' do
      pdf = described_class.new(order, version).render
      expect(pdf).to be_a(String)
      expect(pdf.bytesize).to be > 1000
    end
  end

  describe '#render' do
    it 'returns a non-empty PDF string' do
      result = service.render
      expect(result).to be_present
      expect(result[0..3]).to eq('%PDF') # стандартная сигнатура PDF
    end

    describe '#price' do
      it 'formats THB cents into string' do
        expect(service.send(:price, 10_000)).to eq('฿ 100.00')
      end
    end
  end
end
