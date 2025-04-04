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
FactoryBot.define do
  factory :order_version do
    order
    company
    total_amount { rand(0..10_000) }
    agent_comm { rand(0..100) }
    profit { rand(0..100) }
    version_note { Faker::Lorem.sentence }
    final_version { false }
    category
  end

  trait :final do
    final_version { true }
  end
end
