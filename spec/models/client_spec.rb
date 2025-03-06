# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id         :integer          not null, primary key
#  email      :string
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer          not null
#
# Indexes
#
#  index_clients_on_company_id_and_email  (company_id,email)
#
# Foreign Keys
#
#  company_id  (company_id => companies.id)
#
require 'rails_helper'

RSpec.describe Client, type: :model do
  before do
    create(:client)
  end

  context 'associations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:orders).dependent(:restrict_with_error) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:company_id).case_insensitive }

    context 'when email is blank' do
      let(:existing_client) { create(:client, email: nil) }

      it 'allows to create a new client without email' do
        new_client = build(:client, email: nil, company: existing_client.company)

        expect(new_client).to be_valid
      end
    end
  end

  describe '#normalize_email' do
    let(:client) { build(:client, email: 'Example@email.com ') }

    it 'downcases and strips email' do
      client.save

      expect(client.email).to eq('example@email.com')
    end
  end
end
