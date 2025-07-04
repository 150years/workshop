# frozen_string_literal: true

class CreateInstallationReportItems < ActiveRecord::Migration[8.0]
  def change
    create_table :installation_report_items do |t|
      t.references :installation_report, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :status
      t.text :comment

      t.timestamps
    end
  end
end
