# frozen_string_literal: true

class CreateAgents < ActiveRecord::Migration[8.0]
  def change
    create_table :agents do |t|
      t.string :name, null: false
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
