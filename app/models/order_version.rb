# frozen_string_literal: true

# == Schema Information
#
# Table name: order_versions
#
#  id                    :integer          not null, primary key
#  agent_comm            :integer          default(0), not null
#  final_version         :boolean          default(FALSE), not null
#  note_for_client       :text
#  profit                :integer          default(0), not null
#  quotation_custom_code :string
#  quotation_number      :string
#  total_amount_cents    :integer          default(0), not null
#  version_note          :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :integer          not null
#  order_id              :integer          not null
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
  before_validation :generate_quotation_number, on: :create
  after_save :unset_other_final_versions, if: :saved_change_to_final_version?
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

  after_commit do
    broadcast_update_to self
  end

  scope :final_or_latest, -> { order(final_version: :desc, created_at: :desc).first }

  def update_total_amount
    total = products.reload.sum(&:total_price_with_profit_cents)
    self.total_amount_cents = total
    save
  end

  def quotation_filename(order)
    name = order.name.parameterize.underscore
    "QT_TGT_#{created_at.strftime('%Y%m%d')}_V#{id}_#{name}.pdf"
  end

  def generate_quotation_number
    return if order.nil?

    today = Time.zone.today
    version_number = (order.order_versions.count + 1).to_s
    self.quotation_number = "QT_TGT_#{today.strftime('%Y%m%d')}_V#{version_number}"
  end

  def full_quotation_number
    base = quotation_number
    return base if quotation_custom_code.blank?

    base.sub(/(QT_TGT_\d{8})(?=_V\d+)/) { "#{::Regexp.last_match(1)}/#{quotation_custom_code}" }
  end

  def pdf_filename(order)
    "#{Time.zone.today.strftime('%Y_%m_%d')}_#{quotation_number}_#{order.name.parameterize(separator: '_')}.pdf"
  end

  def unset_other_final_versions
    return unless final_version?

    # rubocop:disable Rails/SkipsModelValidations
    order.order_versions.where.not(id: id).update_all(final_version: false)
    # rubocop:enable Rails/SkipsModelValidations
  end

  def total_profit_amount_cents
    products.sum(&:total_profit_amount_cents)
  end

  def total_profit_amount
    Money.new(total_profit_amount_cents, currency)
  end
end
