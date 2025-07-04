# frozen_string_literal: true

# == Schema Information
#
# Table name: installation_reports
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer          not null
#
# Indexes
#
#  index_installation_reports_on_order_id  (order_id)
#
# Foreign Keys
#
#  order_id  (order_id => orders.id)
#
class InstallationReport < ApplicationRecord
  belongs_to :order
  has_many :installation_report_items, dependent: :destroy
end
