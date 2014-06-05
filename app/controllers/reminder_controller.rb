class ReminderController < ApplicationController
   before_filter :authenticate_user!
   include ::Reminder
   def index
      @patient_vaccines = Reminder.getFutureReminders(current_user.id)
   end
end
