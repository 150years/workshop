# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  address    :string
#  email      :string
#  name       :string           not null
#  phone      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#  tax_id     :string
#
# Indexes
#
#  index_clients_on_company_id_and_email  (company_id,email)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
class Client < ApplicationRecord
  belongs_to :company
  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true
  validates :email, uniqueness: { scope: :company_id }, if: -> { email.present? }

  before_validation :normalize_email, if: -> { email.present? }

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[company orders]
  end

  private

  def normalize_email
    self.email = email.downcase.strip
  end
end
