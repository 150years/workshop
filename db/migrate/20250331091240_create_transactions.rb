# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.date :date
      t.string :description
      t.decimal :amount
      t.integer :type_id
      t.references :order, null: false, foreign_key: true
      t.references :agent, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
