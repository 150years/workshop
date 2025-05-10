# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  id          :integer          not null, primary key
#  amount      :integer          default(0)
#  code        :string
#  name        :string
#  price       :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  supplier_id :integer
#
# Indexes
#
#  index_materials_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  supplier_id  (supplier_id => suppliers.id)
#
class Material < ApplicationRecord
  belongs_to :supplier, optional: true
  has_many :material_uses, dependent: :destroy
  has_one_attached :image
  validates :name, presence: true
  validates :price, presence: true
  validates :code, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(_auth_object = nil)
    %w[code created_at id name price supplier_id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[code created_at id name price supplier_id updated_at]
  end
end
