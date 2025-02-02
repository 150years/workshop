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
  pending "add some examples to (or delete) #{__FILE__}"
end
