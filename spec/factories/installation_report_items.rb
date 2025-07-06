# frozen_string_literal: true

# == Schema Information
#
# Table name: installation_report_items
#
#  id                     :integer          not null, primary key
#  comment                :text
#  comment_thai           :text
#  status                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  installation_report_id :integer          not null
#  product_id             :integer          not null
#
# Indexes
#
#  index_installation_report_items_on_installation_report_id  (installation_report_id)
#  index_installation_report_items_on_product_id              (product_id)
#
# Foreign Keys
#
#  installation_report_id  (installation_report_id => installation_reports.id)
#  product_id              (product_id => products.id)
#
FactoryBot.define do
  factory :installation_report_item do
    association :installation_report
    association :product
    status { :waiting_check }
    comment { 'Test comment' }
  end
end
