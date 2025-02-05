# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id         :integer          not null, primary key
#  comment    :string
#  height     :integer          default(0), not null
#  name       :string           not null
#  width      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
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
