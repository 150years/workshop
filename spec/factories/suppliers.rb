# frozen_string_literal: true

# == Schema Information
#
# Table name: suppliers
#
#  id           :integer          not null, primary key
#  contact_info :text
#  email        :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_suppliers_on_email  (email) UNIQUE
#
FactoryBot.define do
  factory :supplier do
    name { 'Test Supplier' }
    contact_info { 'Some contact info' }
    email { "supplier#{rand(1000)}@example.com" }
  end
end
