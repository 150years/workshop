# frozen_string_literal: true

class CreateOrderVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :order_versions do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :total_amount, null: false, default: 0
      t.integer :agent_comm, null: false, default: 0
      t.text :comment
      t.text :version_note
      t.boolean :final_version, null: false, default: false

      t.timestamps
    end
  end
end
