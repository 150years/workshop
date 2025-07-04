# frozen_string_literal: true

class CreateInstallationReports < ActiveRecord::Migration[8.0]
  def change
    create_table :installation_reports do |t|
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
