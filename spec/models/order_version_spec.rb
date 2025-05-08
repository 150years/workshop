# frozen_string_literal: true

# == Schema Information
#
# Table name: order_versions
#
#  id                 :integer          not null, primary key
#  agent_comm         :integer          default(0), not null
#  final_version      :boolean          default(FALSE), not null
#  profit             :integer          default(0), not null
#  quotation_number   :string
#  total_amount_cents :integer          default(0), not null
#  version_note       :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :integer          not null
#  order_id           :integer          not null
#
# Indexes
#
#  index_order_versions_on_company_id  (company_id)
#  index_order_versions_on_order_id    (order_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#  order_id    (order_id => orders.id)
#
require 'rails_helper'

RSpec.describe OrderVersion, type: :model do
  let(:company) { create(:company) }
  let(:client) { create(:client, company: company) }
  let(:agent) { create(:agent, company: company) }
  let(:order) { create(:order, company: company, client: client, agent: agent) }

  describe 'associations' do
    it { is_expected.to belong_to(:order).required }
    it { is_expected.to have_many(:products).dependent(:destroy) }
    it 'belongs to order' do
      version = OrderVersion.create!(company: company, order: order, total_amount_cents: 1000, final_version: true)
      expect(version.order).to eq(order)
    end
  end

  describe 'delegations' do
    it { should delegate_method(:currency).to(:company) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:agent_comm) }
    it { is_expected.to validate_numericality_of(:agent_comm).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:agent_comm).is_less_than_or_equal_to(100) }
    it { is_expected.to validate_presence_of(:profit) }
    it { is_expected.to validate_numericality_of(:profit).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:profit).is_less_than_or_equal_to(100) }
  end

  describe 'callbacks' do
    let(:order) { create(:order) }
    let(:order_version) { create(:order_version, final_version: false, order:) }

    context 'after save' do
      let!(:old_final_version_order) { create(:order_version, final_version: true, order:) }

      it 'removes other final versions from other after save' do
        expect { order_version.update(final_version: true) }
          .to change { old_final_version_order.reload.final_version }.from(true).to(false)
      end
    end

    context 'after commit' do
      it 'broadcasts updates after commit' do
        expect do
          order_version.update(final_version: true)
        end.to broadcast_to(order_version.to_gid_param)
      end
    end
  end
end
