# frozen_string_literal: true

class CreateDefectLists < ActiveRecord::Migration[8.0]
  def change
    create_table :defect_lists do |t|
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
