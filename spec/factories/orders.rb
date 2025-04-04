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
    name { "Test Order" }
    status { :quotation }
    association :client
    association :agent
    association :company

    trait :with_final_version do
      after(:create) do |order|
        create(:order_version, order:, company: order.company, final_version: true)
      end
    end

    factory :order_with_final_version, traits: [:with_final_version]
  end
end

