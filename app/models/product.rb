# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  comment          :string
#  height           :integer          default(0), not null
#  name             :string           not null
#  price            :integer          default(0), not null
#  width            :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  company_id       :integer          not null
#  order_version_id :integer
#
# Indexes
#
#  index_products_on_company_id        (company_id)
#  index_products_on_order_version_id  (order_version_id)
#
# Foreign Keys
#
#  company_id        (company_id => companies.id)
#  order_version_id  (order_version_id => order_versions.id)
#
class Product < ApplicationRecord
  attribute :from_template, :boolean, default: false
  attribute :template_id, :integer

  belongs_to :company
  belongs_to :order_version, optional: true
  has_many :product_components, dependent: :destroy
  has_many :components, through: :product_components
  has_one_attached :image, dependent: :purge

  before_validation :copy_template, if: -> { from_template? }, on: :create

  validates :name, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than_or_equal_to: 0 }

  after_destroy :update_order_version_total_amount, if: -> { order_version.present? }
  before_commit :update_order_version_total_amount, if: lambda {
    order_version.present? && saved_change_to_price?
  }, on: %i[update create]

  scope :templates, -> { where(order_version: nil) }
  scope :with_image_variants, -> { includes(image_attachment: [blob: { variant_records: :blob }]) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name comment]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[product_components]
  end

  def self.with_only_components(*component_ids)
    joins(:product_components)
      .group('products.id')
      .where(product_components: { component_id: component_ids })
      .having('COUNT(DISTINCT product_components.component_id) = ?', component_ids.size)
  end

  def self.ransackable_scopes(_auth_object = nil)
    [:with_only_components]
  end

  def update_price
    self.price = product_components.joins(:component).sum('components.price * product_components.quantity')
    save
  end

  def update_order_version_total_amount
    order_version.update_total_amount
  end

  def area
    width * height
  end

  def area_m2
    UnitConverter.mm2_to_m2(area)
  end

  def area_ft2
    UnitConverter.mm2_to_ft2(area)
  end

  def perimeter
    2 * (width + height)
  end

  private

  def find_template
    @template = company.products.find_by(id: template_id, order_version: nil)

    return if @template

    errors.add(:template_id, :not_found)
  end

  def copy_template
    template = company.products.find_by(id: template_id, order_version: nil)

    if template
      self.name = template.name
      self.comment = template.comment
      image.attach(template.image.blob)
      self.product_components = template.product_components.map(&:dup)
    else
      errors.add(:template_id, :not_found)
      throw :abort
    end
  end
end
