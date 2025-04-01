# frozen_string_literal: true

# == Schema Information
#
# Table name: suppliers
#
#  id           :integer          not null, primary key
#  contact_info :text
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :supplier do
    name { 'MyString' }
    contact_info { 'MyText' }
  end
end
