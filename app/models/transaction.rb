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
class Transaction < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :agent, optional: true
  belongs_to :client, optional: true

  has_many_attached :files
  enum :type_id, {
    repair: 1,
    top_up: 2,
    payment: 3,
    utilities: 4,
    gasoline: 5,
    salary: 6,
    petty_cash: 7,
    yearly_contracts: 8,
    office: 9,
    other: 10,
    taxes: 11,
    consumables: 12,
    materials: 13,
    equipment: 14,
    equipment_maintenance: 15,
    investments: 16,
    accounting: 17,
    transportation: 18
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

  def amount_money
    Money.from_amount(amount.abs)
  end

  def editable?
    created_at.to_date >= 7.days.ago.to_date
  end
end
