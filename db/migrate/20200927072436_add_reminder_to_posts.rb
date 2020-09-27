class AddReminderToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :reminder_month, :integer
    add_column :posts, :reminder_notice, :string
  end
end
