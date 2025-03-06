# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :company, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.references :agent, null: false, foreign_key: true
      t.string :name
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
