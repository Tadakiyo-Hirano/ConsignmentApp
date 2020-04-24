class AddCodeToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :code, :integr, default: 0, null: false, unique: true
  end
end
