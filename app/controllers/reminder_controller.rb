class ReminderController < ApplicationController
   before_filter :authenticate_user!, :except => ["getSMSReminders"]
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
#      if !params[:doctor_id]
#	 render :json => {:success => false, :error => "Invalid Params"}
#	 return
#      end
#
#      doctor = User.find(params[:doctor_id])
#
#      if doctor.nil?
#	 render :json => {:success => false, :error => "Invalid Params"}
#	 return
#      end

      defaulters = Reminder.getSMSReminders()
#      doctor.setLastReminderRun()

      render :json => {:success => true, :defaulters => defaulters}
   end
end
