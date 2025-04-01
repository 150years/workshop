# frozen_string_literal: true

class CreateBalances < ActiveRecord::Migration[8.0]
  def change
    create_table :balances, &:timestamps
  end
end
