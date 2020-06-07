class AddProductNameToConsignments < ActiveRecord::Migration[6.0]
  def change
    add_column :consignments, :product_name, :string
  end
end
