class ReminderController < ApplicationController
   include ::Reminder
   def index
      Reminder.sendEmailReminders()
   end

   # Response: 
   # defaulters : {
   #      "phone_number" :"text_mesg",
   #          ....
   #        }
   def getSMSReminders
      defaulters = Reminder.getSMSReminders()
      render :json => {:success => true, :defaulters => defaulters}
   end
end
