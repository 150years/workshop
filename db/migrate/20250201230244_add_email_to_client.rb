# frozen_string_literal: true

class AddEmailToClient < ActiveRecord::Migration[8.0]
  def change
    add_column :clients, :email, :string
  end
end
