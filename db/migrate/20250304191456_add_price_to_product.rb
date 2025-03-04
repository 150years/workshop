# frozen_string_literal: true

class AddPriceToProduct < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :price, :integer, null: false, default: 0
  end
end
