# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  amount      :decimal(, )
#  date        :date
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  agent_id    :integer
#  client_id   :integer
#  company_id  :integer
#  order_id    :integer
#  type_id     :integer
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
class Transaction < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :agent, optional: true
  belongs_to :client, optional: true

  has_many_attached :files
  enum :type_id, {
    consumables: 20,
    equipment: 23,
    payment: 6,
    gasoline: 12,
    equipment_maintenance: 24,
    investments: 28,
    materials: 25,
    office: 13,
    other: 16,
    repair: 2,
    salary: 11,
    taxes: 22,
    accounting: 30,
    top_up: 4,
    utilities: 7,
    yearly_contracts: 8,
    petty_cash: 9
  }

  validates :date, :amount, :type_id, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[agent_id amount client_id created_at date description id order_id type_id updated_at]
  end

  def income?
    amount.positive?
  end

  def expense?
    amount.negative?
  end
end
