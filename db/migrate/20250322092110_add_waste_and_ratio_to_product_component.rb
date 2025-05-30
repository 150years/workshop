# frozen_string_literal: true

class AddWasteAndRatioToProductComponent < ActiveRecord::Migration[8.0]
  def change
    add_column :product_components, :quantity_real, :decimal, precision: 7, scale: 1, null: false, default: 0.0
    add_column :product_components, :waste, :decimal, precision: 7, scale: 1, null: false, default: 0.0
    add_column :product_components, :ratio, :decimal, precision: 3, scale: 2, default: 0.00
  end
end
