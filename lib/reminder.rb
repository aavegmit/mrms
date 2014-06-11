module Reminder
   class << self
      include ::CommEngine

      def sendEmailReminders(doctor_id)
	 patient_pending_vaccines = getDefaulters(doctor_id)

	 patient_pending_vaccines.each do |pid, pvs|
	   PatientMailer.daily_reminder(pvs).deliver
	 end
      end

      def getSMSReminders(doctor_id)
	 patient_pending_vaccines = getDefaulters(doctor_id)

	 ret = Hash.new
	 patient_pending_vaccines.each do |pid, pvs|
	   msg = getSMSText(pvs) 
	   ret[pvs[0][:phone_number]] = msg
	 end
	 ret
      end

      def getFutureReminders(doctor_id)
	 select_fields = "patient_id, next_dose_on, patients.first_name as first_name, patients.last_name as last_name,"
	 select_fields += "vaccines.name as vaccine_name"
	 pv = PatientVaccines.select("dose_number, #{select_fields}")
	 		     .joins(:patient)
	 		     .joins(:vaccine)
	 		     .where("next_dose_on > ? and is_next_dose_on_valid = true and patient_vaccines.doctor_id = ?", Date.today, doctor_id)
			     .order("next_dose_on ASC")
	 		     .to_a

	 return pv
      end

      def getDefaulters(doctor_id)
	 select_fields = "patient_id, vaccine_id, patients.first_name, patients.email, patients.phone_number,"
	 select_fields += "vaccines.name"
	 pv = PatientVaccines.select("dose_number, #{select_fields}")
	 		     .joins(:patient)
	 		     .joins(:vaccine)
	 		     .where("next_dose_on = ? and is_next_dose_on_valid = true and patient_vaccines.doctor_id = ?", Date.today, doctor_id)
	 		     .to_a

	 patient_pending_vaccines = Hash.new
	 pv.each do |item|
	    patient_pending_vaccines[item.patient_id] = Array.new if patient_pending_vaccines[item.patient_id].nil?
	    patient_pending_vaccines[item.patient_id].push(item)
	 end

	 return patient_pending_vaccines 
      end

      def getAllDueReminders(patient_id)
	 select_fields = "patient_id, next_dose_on, patients.first_name as first_name, patients.last_name as last_name,"
	 select_fields += "vaccines.name as vaccine_name"
	 pv = PatientVaccines.select("dose_number, #{select_fields}")
	 		     .joins(:patient)
	 		     .joins(:vaccine)
	 		     .where("is_next_dose_on_valid = true and patient_vaccines.patient_id = ?",  patient_id)
			     .order("next_dose_on ASC")
	 		     .to_a

	 return pv
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
