class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :code, default: "", null: false
      t.string :name

      t.timestamps
      
      t.index :code, unique: true
    end
  end
end
