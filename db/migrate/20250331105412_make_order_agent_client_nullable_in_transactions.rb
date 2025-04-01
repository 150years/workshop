# frozen_string_literal: true

class MakeOrderAgentClientNullableInTransactions < ActiveRecord::Migration[7.1]
  def change
    change_column_null :transactions, :order_id, true
    change_column_null :transactions, :agent_id, true
    change_column_null :transactions, :client_id, true
  end
end
