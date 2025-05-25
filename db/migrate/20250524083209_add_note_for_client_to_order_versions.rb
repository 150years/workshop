# frozen_string_literal: true

class AddNoteForClientToOrderVersions < ActiveRecord::Migration[8.0]
  def change
    add_column :order_versions, :note_for_client, :text
  end
end
