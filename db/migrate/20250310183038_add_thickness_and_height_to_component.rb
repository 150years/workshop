# frozen_string_literal: true

class AddThicknessAndHeightToComponent < ActiveRecord::Migration[8.0]
  def change
    add_column :components, :thickness, :decimal, precision: 7, scale: 1
    add_column :components, :height, :decimal, precision: 7, scale: 1
  end
end
