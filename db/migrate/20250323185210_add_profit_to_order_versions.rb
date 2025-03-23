# frozen_string_literal: true

class AddProfitToOrderVersions < ActiveRecord::Migration[8.0]
  def change
    add_column :order_versions, :profit, :integer
  end
end
