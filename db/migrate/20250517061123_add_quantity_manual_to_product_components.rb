# frozen_string_literal: true

class AddQuantityManualToProductComponents < ActiveRecord::Migration[8.0]
  def change
    add_column :product_components, :quantity_manual, :decimal
  end
end
