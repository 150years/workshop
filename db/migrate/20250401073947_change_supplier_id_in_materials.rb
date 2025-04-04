# frozen_string_literal: true

class ChangeSupplierIdInMaterials < ActiveRecord::Migration[6.0]
  def change
    change_column_null :materials, :supplier_id, true
  end
end
