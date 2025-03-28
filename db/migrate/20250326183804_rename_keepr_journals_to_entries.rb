# frozen_string_literal: true

class RenameKeeprJournalsToEntries < ActiveRecord::Migration[7.0]
  def change
    rename_table :keepr_journals, :entries
  end
end
