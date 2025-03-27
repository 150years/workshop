# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  company_id             :integer          not null
#
# Indexes
#
#  index_users_on_company_id            (company_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
class User < ApplicationRecord
  belongs_to :company

  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id name email created_at company_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[company]
  end
end
