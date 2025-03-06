# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  comment          :string
#  height           :integer          default(0), not null
#  name             :string           not null
#  price            :integer          default(0), not null
#  width            :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :integer          not null
#  order_version_id :integer
#
# Indexes
#
#  index_products_on_company_id        (company_id)
#  index_products_on_order_version_id  (order_version_id)
#
# Foreign Keys
#
#  company_id        (company_id => companies.id)
#  order_version_id  (order_version_id => order_versions.id)
#
FactoryBot.define do
  factory :product do
    company
    name { Faker::Commerce.product_name }
    width { Random.rand(1000) }
    height { Random.rand(1000) }
    comment { Faker::Lorem.sentence }
  end

  trait :with_order_version do
    order_version { create(:order_version, company: company) }
  end
end
