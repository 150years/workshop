# frozen_string_literal: true

class StockMovement < ApplicationRecord
  belongs_to :component
  belongs_to :order, optional: true
  belongs_to :user, optional: true

  enum :movement_type, {
    inbound: 0,
    to_project: 1,
    used: 2,
    returned_to_stock: 3
  }

  validates :quantity, numericality: { greater_than: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[component_id order_id movement_type quantity comment created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[component order]
  end

  def self.sum_by_type
    inbound = where(movement_type: :inbound).sum(:quantity)
    returned = where(movement_type: :returned_to_stock).sum(:quantity)
    to_project = where(movement_type: :to_project).sum(:quantity)
    used = where(movement_type: :used).sum(:quantity)

    (inbound + returned) - to_project - used
  end
end
