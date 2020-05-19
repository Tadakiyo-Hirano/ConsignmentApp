class CreateConsignments < ActiveRecord::Migration[6.0]
  def change
    create_table :consignments do |t|
      t.date :ship_date
      t.string :customer_info
      t.string :product_info
      t.string :serial_number
      t.string :note
      t.integer :quantity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
