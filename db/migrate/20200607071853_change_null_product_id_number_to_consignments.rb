class ChangeNullProductIdNumberToConsignments < ActiveRecord::Migration[6.0]
  def up
    change_column :consignments, :product_id_number, :integer, null: false
  end
  
  def down
    change_column :consignments, :product_id_number, :integer
  end
end
