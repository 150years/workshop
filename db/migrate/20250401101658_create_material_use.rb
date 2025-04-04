# frozen_string_literal: true

class CreateMaterialUse < ActiveRecord::Migration[8.0]
  def change
    create_table :material_expenses do |t|
      t.date :date
      t.integer :amount
      t.string :project
      t.references :material, null: false, foreign_key: true

      t.timestamps
    end
  end
end
