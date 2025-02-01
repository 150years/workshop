# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
