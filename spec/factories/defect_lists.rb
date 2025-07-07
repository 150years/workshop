# frozen_string_literal: true

FactoryBot.define do
  factory :defect_list do
    association :order
  end
end
