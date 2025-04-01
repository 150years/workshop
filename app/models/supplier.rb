# frozen_string_literal: true

# == Schema Information
#
# Table name: suppliers
#
#  id           :integer          not null, primary key
#  contact_info :text
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Supplier < ApplicationRecord
  has_many :materials, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :contact_info, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[code created_at id name contact_info updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[code created_at id name contact_info updated_at]
  end
end
