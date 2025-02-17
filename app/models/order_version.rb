# frozen_string_literal: true

# == Schema Information
#
# Table name: order_versions
#
#  id            :integer          not null, primary key
#  agent_comm    :integer          default(0), not null
#  comment       :text
#  final_version :boolean          default(FALSE), not null
#  total_amount  :integer          default(0), not null
#  version_note  :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  order_id      :integer          not null
#
# Indexes
#
#  index_order_versions_on_order_id  (order_id)
#
# Foreign Keys
#
#  order_id  (order_id => orders.id)
#
class OrderVersion < ApplicationRecord
  belongs_to :order
  has_many :products, dependent: :destroy

  validates :total_amount, :agent_comm, presence: true,
                                        numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :agent_comm, numericality: { less_than_or_equal_to: 100 }
end
