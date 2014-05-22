class AddLastReminderRunToUsers < ActiveRecord::Migration
  def change
     add_column :users, :last_reminder_run, :date
  end
end
