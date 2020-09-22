class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :month_day
      t.string :month_notice
      t.integer :year_month
      t.integer :year_day
      t.string :year_notice

      t.timestamps
    end
  end
end
