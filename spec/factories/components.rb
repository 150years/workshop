# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  category     :integer          default("aluminum"), not null
#  code         :string           not null
#  color        :string
#  height       :decimal(7, 1)
#  length       :decimal(7, 1)
#  min_quantity :decimal(7, 1)
#  name         :string           not null
#  note         :string
#  price_cents  :integer          default(0), not null
#  thickness    :decimal(7, 1)
#  unit         :integer          not null
#  weight       :decimal(7, 1)
#  width        :decimal(7, 1)
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
    category { %w[aluminum glass other].sample }
    name { Faker::Commerce.product_name }
    color { "#{Faker::Color.color_name} / #{Faker::Color.color_name}" }
    unit { %w[mm pc lot m m2 kg lines].sample }
    width { rand(100..1000) }
    length { rand(100..1000) }
    height { rand(100..1000) }
    thickness { rand(1..10) }
    weight { rand(10..10_000) }
    min_quantity { rand(1.0..99.9) }
    price_cents { rand(10..10_000) }
    note { Faker::Lorem.sentence }
    company

    trait :with_image do
      after(:build) do |component|
        component.image.attach(io: Rails.root.join('spec/fixtures/files/image.jpg').open, filename: 'image.jpg', content_type: 'image/jpg')
      end
    end
  end
end
