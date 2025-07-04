# frozen_string_literal: true

FactoryBot.define do
  factory :installation_report do
    association :order
  end
end
