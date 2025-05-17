# frozen_string_literal: true

class AddQuotationCustomCodeToOrderVersions < ActiveRecord::Migration[7.1]
  def change
    return if column_exists?(:order_versions, :quotation_custom_code)

    add_column :order_versions, :quotation_custom_code, :string
  end
end
