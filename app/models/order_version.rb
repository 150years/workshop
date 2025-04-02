# frozen_string_literal: true

# == Schema Information
#
# Table name: order_versions
#
#  id                 :integer          not null, primary key
#  agent_comm         :integer          default(0), not null
#  final_version      :boolean          default(FALSE), not null
#  profit             :integer          default(0), not null
#  total_amount_cents :integer          default(0), not null
#  version_note       :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  company_id         :integer          not null
#  order_id           :integer          not null
#
# Indexes
#
#  index_order_versions_on_company_id  (company_id)
#  index_order_versions_on_order_id    (order_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#  order_id    (order_id => orders.id)
#
class OrderVersion < ApplicationRecord
  delegate :currency, to: :company, allow_nil: true
  monetize :total_amount_cents, with_model_currency: :currency

  belongs_to :company
  belongs_to :order
  has_many :products, dependent: :destroy

  validates :agent_comm, :profit, presence: true,
                                  numericality: {
                                    only_integer: true,
                                    greater_than_or_equal_to: 0,
                                    less_than_or_equal_to: 100
                                  }
  after_save :remove_other_final_versions, if: -> { saved_change_to_final_version? && final_version? }

  after_commit do
    broadcast_update_to self
  end

  scope :final_or_latest, -> { order(final_version: :desc, created_at: :desc).first }

  def update_total_amount
    self.total_amount_cents = products.sum(&:price_cents)
    save
  end

  private

  def remove_other_final_versions
    order.order_versions.where.not(id: id).update_all(final_version: false) # rubocop:disable Rails/SkipsModelValidations
  end
end
