# frozen_string_literal: true

class CreateDefectListItems < ActiveRecord::Migration[8.0]
  def change
    create_table :defect_list_items do |t|
      t.references :defect_list, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :status
      t.string :comment
      t.string :comment_thai

      t.timestamps
    end
  end
end
