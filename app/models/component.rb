# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  code         :string           not null
#  color        :string
#  dimensions   :json             not null
#  min_quantity :integer          default(0), not null
#  name         :string           not null
#  note         :string
#  price        :integer          default(0), not null
#  unit         :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  company_id   :integer
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
  belongs_to :company, optional: true

  enum :unit, { mm: 0, pc: 1, lot: 2, m: 3, m2: 4, kg: 5 }, validate: true, prefix: true # you can call c.unit_mm?

  validates :code, :name, :unit, :dimensions, :min_quantity, :price, presence: true
  validates :price, :min_quantity, numericality: { greater_than_or_equal_to: 0 }
end
