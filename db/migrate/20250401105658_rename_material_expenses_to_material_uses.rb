# frozen_string_literal: true

class RenameMaterialExpensesToMaterialUses < ActiveRecord::Migration[6.0]
  def change
    rename_table :material_expenses, :material_uses
  end
end
