# frozen_string_literal: true

# == Schema Information
#
# Table name: order_versions
#
#  id            :integer          not null, primary key
#  agent_comm    :integer          default(0), not null
#  comment       :text
#  final_version :boolean          default(FALSE), not null
#  total_amount  :integer          default(0), not null
#  version_note  :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  order_id      :integer          not null
#
# Indexes
#
#  index_order_versions_on_order_id  (order_id)
#
# Foreign Keys
#
#  order_id  (order_id => orders.id)
#
require 'rails_helper'

RSpec.describe OrderVersion, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:order).required }
    it { is_expected.to have_many(:products).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:total_amount) }
    it { is_expected.to validate_presence_of(:agent_comm) }
    it { is_expected.to validate_numericality_of(:total_amount).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:agent_comm).only_integer.is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:agent_comm).is_less_than_or_equal_to(100) }
  end
end
