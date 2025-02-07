# frozen_string_literal: true

class CreateProductComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :product_components do |t|
      t.references :product, null: false, foreign_key: true
      t.references :component, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end
  end
end
