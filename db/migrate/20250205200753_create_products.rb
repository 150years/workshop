# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :width, null: false, default: 0
      t.integer :height, null: false, default: 0
      t.string :comment

      t.timestamps
    end
  end
end
