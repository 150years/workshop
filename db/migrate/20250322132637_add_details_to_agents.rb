# frozen_string_literal: true

class AddDetailsToAgents < ActiveRecord::Migration[8.0]
  def change
    add_column :agents, :phone, :string
    add_column :agents, :email, :string
    add_column :agents, :commission, :integer
  end
end
