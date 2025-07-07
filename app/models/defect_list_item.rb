# frozen_string_literal: true

# == Schema Information
#
# Table name: defect_list_items
#
#  id             :integer          not null, primary key
#  comment        :string
#  comment_thai   :string
#  status         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  defect_list_id :integer          not null
#  product_id     :integer          not null
#
# Indexes
#
#  index_defect_list_items_on_defect_list_id  (defect_list_id)
#  index_defect_list_items_on_product_id      (product_id)
#
# Foreign Keys
#
#  defect_list_id  (defect_list_id => defect_lists.id)
#  product_id      (product_id => products.id)
#
class DefectListItem < ApplicationRecord
  belongs_to :defect_list
  belongs_to :product
  has_many_attached :photos

  enum :status, {
    other: 'Other / อื่น',
    scratches: 'Scratches / รอย',
    size_issue: 'Size / ขนาด',
    sealant_color: 'Sealant color / สีซีลแลนท์',
    sealant_quality: 'Sealant quality / คุณภาพของซีลแลนท์',
    sealant_size: 'Sealant size / ขนาดซีลแลนท์',
    gaps: 'Gaps / ช่อง',
    lock_and_handle: 'Lock and handle / ล็อคและจับ'
  }
end
