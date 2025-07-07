# frozen_string_literal: true

FactoryBot.define do
  factory :defect_list_item do
    association :defect_list
    association :product
    status { :other }
    comment { 'Test comment' }
    comment_thai { 'Test comment' }
  end
end
