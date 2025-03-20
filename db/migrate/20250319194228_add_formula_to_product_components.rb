# frozen_string_literal: true

class AddFormulaToProductComponents < ActiveRecord::Migration[8.0]
  def change
    add_column :product_components, :formula, :string
  end
end
