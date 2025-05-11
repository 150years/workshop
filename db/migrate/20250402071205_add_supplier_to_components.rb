# frozen_string_literal: true

class AddSupplierToComponents < ActiveRecord::Migration[7.1]
  def change
    add_reference :components, :supplier, foreign_key: true # убрал null: false
  end
end
