# frozen_string_literal: true

class AddOrderToMaterialUses < ActiveRecord::Migration[6.0]
  def change
    add_reference :material_uses, :order, foreign_key: true
  end
end
