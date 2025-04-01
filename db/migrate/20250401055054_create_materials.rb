# frozen_string_literal: true

class CreateMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :materials do |t|
      t.string :name
      t.float :price
      t.references :supplier, null: false, foreign_key: true
      t.string :code

      t.timestamps
    end
  end
end
