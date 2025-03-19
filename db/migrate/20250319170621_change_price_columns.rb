# frozen_string_literal: true

class ChangePriceColumns < ActiveRecord::Migration[8.0]
  def change
    rename_column :components, :price, :price_cents
    rename_column :products, :price, :price_cents
    rename_column :order_versions, :total_amount, :total_amount_cents
  end
end
