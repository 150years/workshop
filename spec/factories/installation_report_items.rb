# frozen_string_literal: true

FactoryBot.define do
  factory :installation_report_item do
    association :installation_report
    association :product
    status { :waiting_check }
    comment { 'Test comment' }
  end
end
