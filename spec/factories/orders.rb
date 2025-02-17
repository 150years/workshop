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
#  agent_id   :integer          not null
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
FactoryBot.define do
  factory :order do
    association :company
    sequence(:name) { |n| "Order #{n}" }
    status { 0 }

    after(:build) do |order|
      order.client ||= create(:client, company: order.company)
      order.agent ||= create(:agent, company: order.company)
    end
  end

  trait :competed do
    status { 'completed' }
  end
end
