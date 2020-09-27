class AddReminderCheckToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :reminder_check, :boolean, default: false, null: false
  end
end
