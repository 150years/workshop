# frozen_string_literal: true

class ChangeOrderIdNullInTransactions < ActiveRecord::Migration[7.1]
  def change
    change_column_null :transactions, :order_id, true
  end
end
