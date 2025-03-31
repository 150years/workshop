# frozen_string_literal: true

# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  amount      :decimal(, )
#  date        :date
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  agent_id    :integer
#  client_id   :integer
#  order_id    :integer
#  type_id     :integer
#
# Indexes
#
#  index_transactions_on_agent_id   (agent_id)
#  index_transactions_on_client_id  (client_id)
#  index_transactions_on_order_id   (order_id)
#
# Foreign Keys
#
#  agent_id   (agent_id => agents.id)
#  client_id  (client_id => clients.id)
#  order_id   (order_id => orders.id)
#
require 'rails_helper'

RSpec.describe Transaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
