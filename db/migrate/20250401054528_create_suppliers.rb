# frozen_string_literal: true

class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.text :contact_info

      t.timestamps
    end
  end
end
