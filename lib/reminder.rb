module Reminder
   class << self
      include ::CommEngine

      def sendEmailReminders
	 patient_pending_vaccines = getDefaulters()

	 patient_pending_vaccines.each do |pid, pvs|
	   PatientMailer.daily_reminder(pvs).deliver
	 end
      end

      def getSMSReminders
	 patient_pending_vaccines = getDefaulters()

	 ret = Hash.new
	 patient_pending_vaccines.each do |pid, pvs|
	   msg = getSMSText(pvs) 
	   ret[pvs[0][:phone_number]] = msg
	 end
	 ret
      end

      def getDefaulters
	 select_fields = "patient_id, vaccine_id, patients.first_name, patients.email, patients.phone_number,"
	 select_fields += "vaccines.name"
	 pv = PatientVaccines.select("max(dose_number) as dose_num, #{select_fields}")
	 		     .joins(:patient)
	 		     .joins(:vaccine)
	 		     .where("next_dose_on > ?", Date.today)
	 		     .group("#{select_fields}")
	 		     .to_a

	 patient_pending_vaccines = Hash.new
	 pv.each do |item|
	    patient_pending_vaccines[item.patient_id] = Array.new if patient_pending_vaccines[item.patient_id].nil?
	    patient_pending_vaccines[item.patient_id].push(item)
	 end

	 return patient_pending_vaccines 
      end

      private
      def getSMSText(pvs)
	    vaccine_list = ''
	    pvs.each do |v|
	       vaccine_list += v[:name] + ", "
	    end
	    fullMsg = "Dear #{pvs[0][:first_name]}, you are scheduled for the vaccines(s) - #{vaccine_list}"
      end

   end

end
