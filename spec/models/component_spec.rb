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
require 'rails_helper'

RSpec.describe Component, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:company) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:unit).with_values(piece: 0, meter: 1, kilogram: 2) }
    it { is_expected.to define_enum_for(:color).with_values(red: 0, green: 1, blue: 2, yellow: 3, black: 4, white: 5) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end
end
