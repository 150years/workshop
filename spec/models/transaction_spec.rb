# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id                  :integer          not null, primary key
#  amount              :decimal(, )
#  date                :date
#  description         :string
#  hidden              :boolean          default(FALSE), not null
#  only_for_accounting :boolean          default(FALSE), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  agent_id            :integer
#  client_id           :integer
#  company_id          :integer
#  order_id            :integer
#  type_id             :integer
#
# Indexes
#
#  index_transactions_on_agent_id    (agent_id)
#  index_transactions_on_client_id   (client_id)
#  index_transactions_on_company_id  (company_id)
#  index_transactions_on_order_id    (order_id)
#
# Foreign Keys
#
#  agent_id    (agent_id => agents.id)
#  client_id   (client_id => clients.id)
#  company_id  (company_id => companies.id)
#  order_id    (order_id => orders.id)
#
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe '#editable?' do
    it 'returns true for recent transactions' do
      t = build(:transaction, created_at: 2.days.ago)
      expect(t.editable?).to be true
    end

    it 'returns false for transactions older than 7 days' do
      t = build(:transaction, created_at: 8.days.ago)
      expect(t.editable?).to be false
    end
  end
end
