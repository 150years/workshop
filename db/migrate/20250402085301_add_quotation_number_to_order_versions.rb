# frozen_string_literal: true

class AddQuotationNumberToOrderVersions < ActiveRecord::Migration[8.0]
  def change
    add_column :order_versions, :quotation_number, :string
  end
end
