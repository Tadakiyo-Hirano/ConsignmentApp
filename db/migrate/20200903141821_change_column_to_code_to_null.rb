class ChangeColumnToCodeToNull < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :code,:integer, null: false, default: ""
  end
  
  def down
    change_column :users, :code,:integer, null: false, default: 0
  end
end
