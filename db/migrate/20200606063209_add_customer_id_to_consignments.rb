class AddCustomerIdToConsignments < ActiveRecord::Migration[6.0]
  def change
    add_column :consignments, :customer_id, :integer
  end
end
