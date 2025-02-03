# frozen_string_literal: true

class CreateComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :components do |t|
      t.references :company, null: false, foreign_key: true
      t.string :code
      t.integer :color
      t.integer :unit
      t.integer :min_quantity
      t.integer :price, null: false, default: 0

      t.timestamps
    end
  end
end
