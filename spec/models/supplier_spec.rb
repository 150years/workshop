# frozen_string_literal: true

# == Schema Information
#
# Table name: suppliers
#
#  id           :integer          not null, primary key
#  contact_info :text
#  email        :string
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_suppliers_on_email  (email) UNIQUE
#
require 'rails_helper'

RSpec.describe Supplier, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
