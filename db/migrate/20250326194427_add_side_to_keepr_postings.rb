# frozen_string_literal: true

class AddSideToKeeprPostings < ActiveRecord::Migration[8.0]
  def change
    add_column :keepr_postings, :side, :string
  end
end
