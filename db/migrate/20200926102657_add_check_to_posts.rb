class AddCheckToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :month_check, :boolean, default: false, null: false
    add_column :posts, :year_check, :boolean, default: false, null: false
  end
end
