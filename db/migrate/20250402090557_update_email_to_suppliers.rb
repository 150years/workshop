# frozen_string_literal: true

# db/migrate/20250402090557_update_email_to_suppliers.rb
class UpdateEmailToSuppliers < ActiveRecord::Migration[7.1]
  def change
    add_index :suppliers, :email, unique: true
  end
end
