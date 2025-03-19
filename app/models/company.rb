# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  currency   :string           default("THB"), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Company < ApplicationRecord
  SUPPORTED_CURRENCIES = %w[USD THB].freeze

  has_many :users, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :agents, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_versions, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :components, dependent: :destroy

  validates :name, presence: true
  validates :currency, presence: true, inclusion: { in: SUPPORTED_CURRENCIES }
end
