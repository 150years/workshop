# frozen_string_literal: true

class Client < ApplicationRecord
  belongs_to :company
  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true
  validates :email, uniqueness: { scope: :company_id }, if: -> { email.present? }

  before_validation :normalize_email, if: -> { email.present? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name phone email address tax_id created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[company orders]
  end

  private

  def normalize_email
    self.email = email.downcase.strip
  end
end
