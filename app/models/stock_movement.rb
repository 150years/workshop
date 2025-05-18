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
  validate :not_exceed_available_stock
  validate :project_required_for_project_movements

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

  def project_required_for_project_movements
    return if movement_type.blank?

    return unless %w[to_project used returned_to_stock].include?(movement_type) && order_id.blank?

    errors.add(:order_id, 'must be selected for this type of movement')
  end

  def not_exceed_available_stock
    return if component.nil?
    return if quantity.blank?

    case movement_type.to_sym
    when :to_project
      available = component.available_stock_quantity
      errors.add(:quantity, "exceeds available stock (#{available})") if quantity > available
    when :used
      return if order_id.blank?

      available = component.available_project_quantity(order_id)
      errors.add(:quantity, "exceeds available quantity on project (#{available})") if quantity > available
    end
  end
end
