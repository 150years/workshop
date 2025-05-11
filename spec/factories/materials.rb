# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  id          :integer          not null, primary key
#  amount      :integer          default(0)
#  code        :string
#  name        :string
#  price       :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  supplier_id :integer
#
# Indexes
#
#  index_materials_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  supplier_id  (supplier_id => suppliers.id)
#
FactoryBot.define do
  factory :material do
    name { 'MyString' }
    price { 1.5 }
    supplier { nil }
    code { 'MyString' }
  end
end
