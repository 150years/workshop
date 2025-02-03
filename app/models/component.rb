# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  code         :string
#  color        :integer
#  min_quantity :integer
#  price        :integer          default(0), not null
#  unit         :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer          not null
#
# Indexes
#
#  index_components_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
class Component < ApplicationRecord
  belongs_to :company

  enum :unit, { piece: 0, meter: 1, kilogram: 2 }
  enum :color, { red: 0, green: 1, blue: 2, yellow: 3, black: 4, white: 5 }

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
