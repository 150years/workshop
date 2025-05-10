# frozen_string_literal: true

class AddAmountToMaterials < ActiveRecord::Migration[6.0]
  def change
    add_column :materials, :amount, :integer, default: 0
  end
end
