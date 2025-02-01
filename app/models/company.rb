# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Company < ApplicationRecord
  validates :name, presence: true

  has_many :users, dependent: :destroy
  has_many :clients, dependent: :destroy
end
