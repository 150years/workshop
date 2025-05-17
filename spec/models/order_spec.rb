# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  name       :string
#  status     :integer          default("quotation"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  agent_id   :integer
#  client_id  :integer          not null
#  company_id :integer          not null
#
# Indexes
#
#  index_orders_on_agent_id    (agent_id)
#  index_orders_on_client_id   (client_id)
#  index_orders_on_company_id  (company_id)
#
# Foreign Keys
#
#  agent_id    (agent_id => agents.id)
#  client_id   (client_id => clients.id)
#  company_id  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:client) }
    it { is_expected.to have_many(:order_versions) }
  end

  describe 'enums' do
    it do
      is_expected.to define_enum_for(:status)
        .with_values(
          quotation: 0,
          measurement: 1,
          design: 2,
          payment: 3,
          production: 4,
          installation: 5,
          completed: 6,
          canceled: 7
        )
    end
  end

  describe 'callbacks' do
    it 'creates an order version before commit' do
      order = build(:order)
      expect(order).to receive(:create_order_version)
      order.save
    end
  end

  describe '#latest_version_total' do
    let(:order) { create(:order) }

    before do
      create(:order_version, order:, total_amount_cents: 1000, final_version: false)
      create(:order_version, order:, total_amount_cents: 2000, final_version: true)
    end

    it 'returns the latest version total amount' do
      expect(order.latest_version_total).to eq(Money.new(2000, 'THB'))
    end

    it 'returns latest order_vertion total if no final version exists' do
      # rubocop:disable Rails/SkipsModelValidations
      order.order_versions.update_all(final_version: false)
      # rubocop:enable Rails/SkipsModelValidations
      expect(order.latest_version_total).to eq(Money.new(2000, 'THB'))
    end

    it 'returns zero if no order versions exist' do
      order.order_versions.destroy_all
      expect(order.latest_version_total).to eq(Money.new(0, 'THB'))
    end
  end
end
