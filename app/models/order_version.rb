# frozen_string_literal: true

# == Schema Information
#
# Table name: order_versions
#
#  id                 :integer          not null, primary key
#  agent_comm         :integer          default(0), not null
#  final_version      :boolean          default(FALSE), not null
#  profit             :integer          default(0), not null
#  quotation_number   :string
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
    self.total_amount_cents = products.sum(&:price_cents)
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

  def pdf_filename(order)
    "#{Time.zone.today.strftime('%Y_%m_%d')}_#{quotation_number}_#{order.name.parameterize(separator: '_')}.pdf"
  end

  def unset_other_final_versions
    return unless final_version?

    # rubocop:disable Rails/SkipsModelValidations
    order.order_versions.where.not(id: id).update_all(final_version: false)
    # rubocop:enable Rails/SkipsModelValidations
  end

  # def grouped_components_by_category_and_supplier(order, version)
  #   product_components = fetch_product_components(order, version)
  #   group_by_category_and_supplier(product_components)
  # end

  # def fetch_product_components(_order, version)
  #   @grouped_components =
  #     version.products
  #            .includes(product_components: { component: :supplier })
  #            .flat_map(&:product_components)
  #            .group_by { |pc| pc.component.category }
  #            .transform_values do |pcs|
  #       pcs.group_by { |pc| pc.component.supplier }.transform_values do |pc_array|
  #         pc_array.group_by(&:component).transform_values do |pcs_group|
  #           pcs_group.sum(&:quantity)
  #         end
  #       end
  #     end
  # end
  # def group_by_category_and_supplier(components)
  #   components.group_by { |pc| pc.component.category }
  #             .transform_values do |pcs|
  #               group_by_supplier(pcs)
  #             end
  # end

  # def group_by_supplier(pcs)
  #   pcs.group_by { |pc| pc.component.supplier }
  #      .transform_values { |pcs_for_supplier| group_by_component(pcs_for_supplier) }
  # end

  # def group_by_component(pcs)
  #   pcs.group_by(&:component).transform_values { |group| group.sum(&:quantity) }
  # end
end
