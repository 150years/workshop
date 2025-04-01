# frozen_string_literal: true

class AddCompanyIdToTransactions < ActiveRecord::Migration[8.0]
  def change
    add_reference :transactions, :company, foreign_key: true
  end
end
