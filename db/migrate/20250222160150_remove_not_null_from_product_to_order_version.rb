# frozen_string_literal: true

class RemoveNotNullFromProductToOrderVersion < ActiveRecord::Migration[8.0]
  def change
    change_column_null :products, :order_version_id, true
  end
end
