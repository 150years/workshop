# frozen_string_literal: true

class AddOrderVersionToProduct < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :order_version, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
    add_reference :products, :company, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
  end
end
