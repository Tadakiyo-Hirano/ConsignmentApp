class RemoveConsignmentQuantityFromStocks < ActiveRecord::Migration[6.0]
  def up
    remove_column :stocks, :consignment_quantity
  end
  
  def down
    add_column :stocks, :consignment_quantity, :integer, default: 0, null: false
  end
end
