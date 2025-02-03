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
require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:users).dependent(:destroy) }
    it { is_expected.to have_many(:clients).dependent(:destroy) }
    it { is_expected.to have_many(:agents).dependent(:destroy) }
    it { is_expected.to have_many(:components).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
