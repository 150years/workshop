# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  comment    :string
#  height     :integer          default(0), not null
#  name       :string           not null
#  width      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    width { Random.rand(1000) }
    height { Random.rand(1000) }
    comment { Faker::Lorem.sentence }
  end
end
