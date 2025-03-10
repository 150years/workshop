# frozen_string_literal: true

# == Schema Information
#
# Table name: components
#
#  id           :integer          not null, primary key
#  code         :string           not null
#  color        :string
#  length       :integer
#  min_quantity :integer          default(0), not null
#  name         :string           not null
#  note         :string
#  price        :integer          default(0), not null
#  unit         :integer          not null
#  weight       :integer
#  width        :integer
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
require 'rails_helper'

RSpec.describe Component, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:company).optional }
    it { is_expected.to have_many(:product_components).dependent(:destroy) }
  end

  describe 'active storage' do
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:unit).with_values(mm: 0, pc: 1, lot: 2, m: 3, m2: 4, kg: 5, lines: 6).with_prefix }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:unit) }
    it { is_expected.to validate_presence_of(:min_quantity) }
    it { is_expected.to validate_presence_of(:price) }

    it { is_expected.to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:length).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:width).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:weight).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:min_quantity).is_greater_than_or_equal_to(0) }
  end
end
