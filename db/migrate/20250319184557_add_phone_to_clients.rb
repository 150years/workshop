# frozen_string_literal: true

class AddPhoneToClients < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :phone, :string
  end
end
