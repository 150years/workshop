# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  code         :string           not null
#  color        :string
#  height       :decimal(7, 1)
#  length       :decimal(7, 1)
#  min_quantity :decimal(7, 1)
#  name         :string           not null
#  note         :string
#  price_cents  :integer          default(0), not null
#  thickness    :decimal(7, 1)
#  unit         :integer          not null
#  weight       :decimal(7, 1)
#  width        :decimal(7, 1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer
#
# Indexes
#
#  index_components_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
class Component < ApplicationRecord
  delegate :currency, to: :company, allow_nil: true
  monetize :price_cents, with_model_currency: :currency

  belongs_to :company, optional: true
  has_many :product_components, dependent: :restrict_with_error
  has_many :products, through: :product_components
  has_one_attached :image

  # Call "component.unit_mm?" to check if the unit is mm
  enum :unit, { mm: 0, pc: 1, lot: 2, m: 3, m2: 4, kg: 5, lines: 6 },
       validate: true, prefix: true

  validates :code, :name, :unit, :min_quantity, presence: true
  validates :length, :width, :height, :thickness, :weight, :min_quantity,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # If component price has changed, then it should call update_price on products that use this component
  after_save :update_products_total_amount, if: -> { saved_change_to_price_cents? }

  scope :with_image_variants, -> { includes(image_attachment: [blob: { variant_records: :blob }]) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id code name color unit length width height thickness weight min_quantity price]
  end

  def self.ransackable_associations(_auth_object = nil)
    authorizable_ransackable_associations
  end

  def update_products_total_amount
    product_components.each do |product_component|
      product_component.product.update_price
    end
  end

  def area
    width * length
  end

  def perimeter
    2 * (width + length)
  end
end
