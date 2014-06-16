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
	 		     .where("is_next_dose_on_valid = true and patient_vaccines.doctor_id = ? and (valid_until >= ? or valid_until is null) and last_reminder_on is null", doctor_id, Date.today)
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
	 		     .where("next_dose_on <= ? and is_next_dose_on_valid = true and patient_vaccines.doctor_id = ? and (valid_until >= ? or valid_until is null ) and last_reminder_on is null", Date.today+7, doctor_id, Date.today)
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
	 select_fields += "vaccines.name as vaccine_name, valid_until, last_reminder_on"
	 pv = PatientVaccines.select("dose_number, #{select_fields}")
	 		     .joins(:patient)
	 		     .joins(:vaccine)
	 		     .where("is_next_dose_on_valid = true and patient_vaccines.patient_id = ? and (valid_until > ? or valid_until is null)",  patient_id, Date.today)
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
	    fullMsg = "Dear Mr. #{pvs[0][:fathers_name]}, This is to remind about next vaccination of your child #{pvs[0][:first_name]} #{pvs[0][:last_name]}. #{vaccine_list} are due at Dr Mahesh Mittal Clinic, 17, K.N.Modi Complex GT Road, Modinagar. Ignore this message if your child has received this dose to avoid unnecessary reminder."
      end

   end
end
