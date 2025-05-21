# frozen_string_literal: true

class AddHiddenFlagsToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_column :transactions, :hidden, :boolean, default: false, null: false
    add_column :transactions, :only_for_accounting, :boolean, default: false, null: false
  end
end
