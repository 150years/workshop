# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  code         :string
#  color        :integer
#  min_quantity :integer
#  price        :integer          default(0), not null
#  unit         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer          not null
#
# Indexes
#
#  index_components_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
FactoryBot.define do
  factory :component do
    code { Faker::Alphanumeric.alphanumeric(number: 10) }
    color { 'red' }
    unit { 'piece' }
    min_quantity { 1 }
    price { 1 }
    company
  end
end
