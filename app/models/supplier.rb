# frozen_string_literal: true

# == Schema Information
#
# Table name: suppliers
#
#  id           :integer          not null, primary key
#  contact_info :text
#  email        :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_suppliers_on_email  (email) UNIQUE
#
class Supplier < ApplicationRecord
  has_many :materials, dependent: :restrict_with_exception
  has_many :components, dependent: :destroy
  validates :name, presence: true
  validates :contact_info, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.ransackable_attributes(_auth_object = nil)
    %w[code created_at id name contact_info updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[code created_at id name contact_info updated_at]
  end
end
