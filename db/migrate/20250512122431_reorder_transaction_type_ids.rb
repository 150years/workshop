# frozen_string_literal: true

class ReorderTransactionTypeIds < ActiveRecord::Migration[8.0]
  OLD_TO_NEW = {
    2 => 1,   # repair
    4 => 2,   # top_up
    6 => 3,   # payment
    7 => 4,   # utilities
    12 => 5,  # gasoline
    11 => 6,  # salary
    9 => 7,   # petty_cash
    8 => 8,   # yearly_contracts
    13 => 9,  # office
    16 => 10, # other
    22 => 11, # taxes
    20 => 12, # consumables
    25 => 13, # materials
    23 => 14, # equipment
    24 => 15, # equipment_maintenance
    28 => 16, # investments
    30 => 17  # accounting
  }.freeze

  def up
    OLD_TO_NEW.each do |old, new|
      Transaction.where(type_id: old).update_all(type_id: new)
    end
  end

  def down
    OLD_TO_NEW.invert.each do |new, old|
      Transaction.where(type_id: new).update_all(type_id: old)
    end
  end
end
