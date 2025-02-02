# frozen_string_literal: true

# == Schema Information
#
# Table name: agents
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#
# Indexes
#
#  index_agents_on_company_id  (company_id)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Agent, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:company) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
