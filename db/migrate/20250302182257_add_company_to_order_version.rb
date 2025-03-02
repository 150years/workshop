# frozen_string_literal: true

class AddCompanyToOrderVersion < ActiveRecord::Migration[8.0]
  def change
    add_reference :order_versions, :company, null: false, foreign_key: true
  end
end
