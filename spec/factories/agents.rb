# frozen_string_literal: true

# == Schema Information
#
# Table name: agents
#
#  id         :integer          not null, primary key
#  commission :integer
#  email      :string
#  name       :string           not null
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#
# Indexes
#
#  index_agents_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
FactoryBot.define do
  factory :agent do
    name { Faker::Name.name }
    company
  end
end
