# frozen_string_literal: true

class AddCurrencyToCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :companies, :currency, :string, default: 'THB', null: false
  end
end
