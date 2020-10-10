class AddUserNameToConsignments < ActiveRecord::Migration[6.0]
  def change
    add_column :consignments, :user_name, :string, null: false
  end
end
