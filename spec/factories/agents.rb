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
    email { [Faker::Internet.email, nil].sample }
    phone { [Faker::PhoneNumber.phone_number, nil].sample }
    commission { Random.rand(100) }
  end

  trait :with_passport do
    after(:build) do |agent|
      agent.passport.attach(io: Rails.root.join('spec/fixtures/files/dummy.pdf').open, filename: 'passport.pdf', content_type: 'application/pdf')
    end
  end

  trait :with_workpermit do
    after(:build) do |agent|
      agent.workpermit.attach(io: Rails.root.join('spec/fixtures/files/dummy.pdf').open, filename: 'workpermit.pdf', content_type: 'application/pdf')
    end
  end
end
