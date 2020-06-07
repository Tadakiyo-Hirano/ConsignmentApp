class AddProductIdNumberToConsignments < ActiveRecord::Migration[6.0]
  def change
    add_column :consignments, :product_id_number, :integer
  end
end
