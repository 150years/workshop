# frozen_string_literal: true

class ChangeMinQuantityNullableInComponents < ActiveRecord::Migration[8.0]
  def change
    change_column_null :components, :min_quantity, true
  end
end
