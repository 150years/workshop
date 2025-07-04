# frozen_string_literal: true

# == Schema Information
#
# Table name: installation_report_items
#
#  id                     :integer          not null, primary key
#  comment                :text
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
class InstallationReportItem < ApplicationRecord
  belongs_to :installation_report
  belongs_to :product
  has_many_attached :photos

  enum :status, {
    waiting_check: 'Waiting check',
    place_not_ready: 'Place not ready',
    waiting_installation: 'Waiting installation',
    frame_installed: 'Frame installed',
    sash_installed: 'Sash installed',
    adjustments_and_details: 'Adjustments and details',
    completed: 'Completed'
  }
end
