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
FactoryBot.define do
  factory :transaction do
    date { Time.zone.today }
    description { Faker::Lorem.sentence(word_count: 3) }
    amount { rand(-1000.0..1000.0).round(2) }
    type_id { Transaction.type_ids.keys.sample }
    order { nil }
    agent { nil }
    client { nil }
  end
end
