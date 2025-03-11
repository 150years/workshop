# frozen_string_literal: true

class ChangeProductComponentQuantityToDecimal < ActiveRecord::Migration[8.0]
  def up
    change_column :product_components, :quantity, :decimal, precision: 7, scale: 1, null: false, default: 0.0
  end

  def down
    change_column :product_components, :quantity, :integer
  end
end
