# frozen_string_literal: true

# == Schema Information
#
# Table name: defect_lists
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :integer          not null
#
# Indexes
#
#  index_defect_lists_on_order_id  (order_id)
#
# Foreign Keys
#
#  order_id  (order_id => orders.id)
#
class DefectList < ApplicationRecord
  belongs_to :order
  has_many :defect_list_items, dependent: :destroy
end
