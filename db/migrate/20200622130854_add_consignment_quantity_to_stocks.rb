class AddConsignmentQuantityToStocks < ActiveRecord::Migration[6.0]
  def change
    add_column :stocks, :consignment_quantity, :integer
  end
end
