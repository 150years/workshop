# frozen_string_literal: true

class ChangeWeightInComponentFromIntegerToDecimal < ActiveRecord::Migration[8.0]
  def up
    change_column :components, :weight, :decimal, precision: 7, scale: 1
  end

  def down
    change_column :components, :weight, :integer
  end
end
