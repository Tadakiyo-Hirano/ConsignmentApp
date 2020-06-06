class AddCustomerNameToConsignments < ActiveRecord::Migration[6.0]
  def change
    add_column :consignments, :customer_name, :string
  end
end
