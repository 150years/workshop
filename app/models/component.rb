# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  code         :string           not null
#  color        :string
#  length       :integer
#  min_quantity :integer          default(0), not null
#  name         :string           not null
#  note         :string
#  price        :integer          default(0), not null
#  unit         :integer          not null
#  weight       :integer
#  width        :integer
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
  belongs_to :company, optional: true
  has_many :product_components, dependent: :destroy
  has_one_attached :image

  enum :unit, { mm: 0, pc: 1, lot: 2, m: 3, m2: 4, kg: 5 }, validate: true, prefix: true # you can call c.unit_mm?

  validates :code, :name, :unit, :min_quantity, :price, presence: true
  validates :price, :length, :width, :weight, :min_quantity, numericality: { greater_than_or_equal_to: 0 }

  # If component price has changed, then it should call update_price on products that use this component
  after_save :update_products_total_amount, if: -> { saved_change_to_price? }

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
