# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  id          :integer          not null, primary key
#  amount      :integer          default(0)
#  code        :string
#  name        :string
#  price       :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  supplier_id :integer
#
# Indexes
#
#  index_materials_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  supplier_id  (supplier_id => suppliers.id)
#
require 'rails_helper'

RSpec.describe Material, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
