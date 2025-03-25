# frozen_string_literal: true

class AddNotNullToOrderVersionProfit < ActiveRecord::Migration[8.0]
  def change
    OrderVersion.where(profit: nil).update_all(profit: 0)
    change_column :order_versions, :profit, :integer, null: false, default: 0
  end
end
