class RenameCustomerInfoAndProductInfoColumnToCosignments < ActiveRecord::Migration[6.0]
  def change
    rename_column :consignments, :customer_info, :customer_code
    rename_column :consignments, :product_info, :product_code
  end
end
