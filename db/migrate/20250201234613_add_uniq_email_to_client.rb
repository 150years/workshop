# frozen_string_literal: true

class AddUniqEmailToClient < ActiveRecord::Migration[8.0]
  def change
    remove_index :clients, :company_id
    add_index :clients, %i[company_id email]
  end
end
