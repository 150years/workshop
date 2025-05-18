# frozen_string_literal: true

class CreateStockMovements < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_movements do |t|
      t.references :component, null: false, foreign_key: true
      t.references :order, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :quantity, null: false
      t.integer :movement_type, null: false
      t.text :comment

      t.timestamps
    end
  end
end
