# frozen_string_literal: true

class AddEmailToSuppliers < ActiveRecord::Migration[8.0]
  def change
    add_column :suppliers, :email, :string
  end
end
