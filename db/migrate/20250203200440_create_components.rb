# frozen_string_literal: true

class CreateComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :components do |t|
      t.references :company, foreign_key: true
      t.string :code, null: false
      t.string :name, null: false
      t.string :color
      t.integer :unit, null: false
      t.integer :width
      t.integer :length
      t.integer :weight
      t.integer :min_quantity, null: false, default: 0
      t.integer :price, null: false, default: 0
      t.string :note

      t.timestamps
    end
  end
end
