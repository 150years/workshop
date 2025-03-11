# frozen_string_literal: true

class ConfigureDimensionUnitsForComponents < ActiveRecord::Migration[8.0]
  def up
    change_column :components, :width, :decimal, precision: 7, scale: 1
    change_column :components, :length, :decimal, precision: 7, scale: 1
    change_column :components, :min_quantity, :decimal, precision: 7, scale: 1
  end

  def down
    change_column :components, :width, :integer
    change_column :components, :length, :integer
    change_column :components, :min_quantity, :integer
  end
end
