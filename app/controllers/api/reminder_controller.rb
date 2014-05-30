module Api
   class ReminderController < Api::ApiController
      include ::Reminder
      before_filter :authenticate_user

      # Response: 
      # defaulters : {
      #      "phone_number" :"text_mesg",
      #          ....
      #        }
      def getSMSReminders
	 defaulters = Reminder.getSMSReminders(current_user.id)
	 @current_user.setLastReminderRun()

	 render :json => {:success => true, :defaulters => defaulters}
      end
   end
end
