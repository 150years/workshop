# frozen_string_literal: true

class DropMaterialsAndMaterialUses < ActiveRecord::Migration[7.1]
  def change
    drop_table :material_uses do |t|
      t.date 'date'
      t.integer 'amount'
      t.string 'project'
      t.integer 'material_id', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'order_id'
      t.index ['material_id'], name: 'index_material_uses_on_material_id'
      t.index ['order_id'], name: 'index_material_uses_on_order_id'
    end

    drop_table :materials do |t|
      t.string 'name'
      t.float 'price'
      t.integer 'supplier_id'
      t.string 'code'
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.integer 'amount', default: 0
      t.index ['supplier_id'], name: 'index_materials_on_supplier_id'
    end
  end
end
