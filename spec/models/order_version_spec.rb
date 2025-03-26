# frozen_string_literal: true

# == Schema Information
#
# Table name: order_versions
#
#  id                 :integer          not null, primary key
#  agent_comm         :integer          default(0), not null
#  final_version      :boolean          default(FALSE), not null
#  profit             :integer          default(0), not null
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
  describe 'associations' do
    it { is_expected.to belong_to(:order).required }
    it { is_expected.to have_many(:products).dependent(:destroy) }
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
end
