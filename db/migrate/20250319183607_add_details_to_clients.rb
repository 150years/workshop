# frozen_string_literal: true

class AddDetailsToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :address, :string
    add_column :clients, :tax_id, :string
  end
end
