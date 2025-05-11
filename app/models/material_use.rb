# frozen_string_literal: true

# == Schema Information
#
# Table name: material_uses
#
#  id          :integer          not null, primary key
#  amount      :integer
#  date        :date
#  project     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  material_id :integer          not null
#  order_id    :integer
#
# Indexes
#
#  index_material_uses_on_material_id  (material_id)
#  index_material_uses_on_order_id     (order_id)
#
# Foreign Keys
#
#  material_id  (material_id => materials.id)
#  order_id     (order_id => orders.id)
#
class MaterialUse < ApplicationRecord
  belongs_to :material
  belongs_to :order, optional: true

  validates :amount, numericality: { greater_than: 0 }
  validates :date, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id amount date project project updated_at created_at order_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[id amount date project project updated_at created_at order_id]
  end
end
