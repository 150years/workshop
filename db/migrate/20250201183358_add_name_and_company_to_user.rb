# frozen_string_literal: true

class AddNameAndCompanyToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string, null: false # rubocop:disable Rails/NotNullColumn
    add_reference :users, :company, null: false, foreign_key: true # rubocop:disable Rails/NotNullColumn
  end
end
