# frozen_string_literal: true

class AddTimestampsToKeeprTables < ActiveRecord::Migration[7.1]
  def change
    change_table :keepr_groups do |t|
      t.timestamps null: true
    end

    change_table :keepr_taxes do |t|
      t.timestamps null: true
    end

    change_table :keepr_cost_centers do |t|
      t.timestamps null: true
    end

    change_table :keepr_postings do |t|
      t.timestamps null: true
    end
  end
end
