class ReminderController < ApplicationController
   include ::Reminder
   def index
      Reminder.dailyReminder()
   end
end
