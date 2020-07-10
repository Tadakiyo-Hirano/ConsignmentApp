class AddDoneToConsignments < ActiveRecord::Migration[6.0]
  def change
    add_column :consignments, :done, :boolean, default: false, null: false
  end
end
