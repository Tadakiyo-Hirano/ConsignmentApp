class ChangeNullQuantityToConsignments < ActiveRecord::Migration[6.0]
  def up
    change_column :consignments, :quantity, :integer, null: false
  end
  
  def down
    change_column :consignments, :quantity, :integer
  end
end
