# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id               :integer          not null, primary key
#  comment          :string
#  height           :integer          default(0), not null
#  name             :string           not null
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
  belongs_to :company
  belongs_to :order_version, optional: true
  has_many :product_components, dependent: :destroy
  has_one_attached :image

  validates :name, :width, :height, presence: true
  validates :width, :height, numericality: { greater_than_or_equal_to: 0 }

  def area
    width * height
  end

  def perimeter
    2 * (width + height)
  end
end
