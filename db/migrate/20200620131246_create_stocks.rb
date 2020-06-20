class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.integer :return_quantity, default: 0, null: false
      t.integer :sales_quantity, default: 0, null: false
      t.references :consignment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
