class AddValidUntilAndLastReminderInPv < ActiveRecord::Migration
  def change
     add_column :patient_vaccines, :valid_until, :date
     add_column :patient_vaccines, :last_reminder_on, :date
  end
end
