class ReminderController < ApplicationController
   before_filter :authenticate_user!, :except => ["getSMSReminders"]
   include ::Reminder
   def index
      Reminder.sendEmailReminders()
   end
end
