# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  code         :string           not null
#  color        :string
#  length       :integer
#  min_quantity :integer          default(0), not null
#  name         :string           not null
#  note         :string
#  price        :integer          default(0), not null
#  unit         :integer          not null
#  weight       :integer
#  width        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer
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
    name { Faker::Commerce.product_name }
    color { 'Grey sahara / 8820 Sapphire grey sahara' }
    unit { 'mm' }
    width { 100 }
    length { 100 }
    weight { 100 }
    min_quantity { 1 }
    price { 100 }
    note { Faker::Lorem.sentence }
    company
  end
end
