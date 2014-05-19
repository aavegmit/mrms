module Reminder
   class << self
      include ::CommEngine

      def sendEmailReminders
	 patient_pending_vaccines, patients_info, vaccines_info = getDefaulters()

	 patient_pending_vaccines.each do |pid, vaccines|
	   PatientMailer.daily_reminder(patients_info[pid], vaccines_info, vaccines).deliver
	 end
      end

      def getSMSReminders
	 patient_pending_vaccines, patients_info, vaccines_info = getDefaulters()

	 ret = Hash.new
	 patient_pending_vaccines.each do |pid, vaccines|
	   msg = getSMSText(patients_info[pid], vaccines_info, vaccines) 
	   ret[patients_info[pid][:phone_number]] = msg
	 end
	 ret
      end

      def getDefaulters
	 pv = PatientVaccines.select("max(dose_number) as dose_num, patient_id, vaccine_id").where("next_dose_on > ?", Date.today).group("vaccine_id, patient_id").to_a
	 patient_id_map = pv.map {|u| u.patient_id}
	 patient_id_map.uniq!

	 vaccine_id_map = pv.map {|u| u.vaccine_id}
	 # create a mapping of patient Id to the info
	 patients_info = Hash[Patient.select(:phone_number,:email, :first_name, :last_name, :id).where(:id => patient_id_map).to_a.map {|u| [u.id, u]}]
	 # create a mapping of vaccine ID to the info
	 vaccines_info = Hash[Vaccine.select(:name, :id).where(:id => vaccine_id_map).to_a.map {|u| [u.id, u]}]

	 patient_pending_vaccines = Hash.new
	 pv.each do |item|
	    patient_pending_vaccines[item.patient_id] = Array.new if patient_pending_vaccines[item.patient_id].nil?
	    patient_pending_vaccines[item.patient_id].push(item)
	 end

	 return patient_pending_vaccines, patients_info, vaccines_info
      end

      private
      def getSMSText(patient_info, vaccines_info, pvs)
	    vaccine_list = ''
	    pvs.each do |v|
	       vaccine_list += vaccines_info[v.vaccine_id][:name] + ", "
	    end
	    fullMsg = "Dear #{patient_info[:first_name]}, you are scheduled for the vaccines(s) - #{vaccine_list}"
      end

   end

end
