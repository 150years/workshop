# frozen_string_literal: true

class AddOrderAndOrderVersionToKeeprJournals < ActiveRecord::Migration[8.0]
  def change
    add_reference :keepr_journals, :order, default: false, null: false, foreign_key: true
    # add_reference :keepr_journals, :order_version, default: false, null: false, foreign_key: true
  end
end
