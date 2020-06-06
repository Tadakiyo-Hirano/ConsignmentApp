class RenameCustomerIdColumnToConsignments < ActiveRecord::Migration[6.0]
  def change
    rename_column :consignments, :customer_id, :customer_id_number
  end
end
