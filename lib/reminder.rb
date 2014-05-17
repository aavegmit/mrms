module Reminder
   class << self
      include ::CommEngine

      def dailyReminder
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

	 patient_pending_vaccines.each do |pid, vaccines|
	   # msg = getText(:email, patients_info[pid], vaccines_info, vaccines) 
	   # CommEngine.sendViaEmail(patients_info[pid][:email], msg)
	   PatientMailer.daily_reminder(patients_info[pid], vaccines_info, vaccines).deliver
	 end
      end

      private
      def getText(type,patient_info, vaccines_info, pvs)
	 case type
	 when :email
	    getEmailText(patient_info, vaccines_info, pvs)
	 when :sms
	    getSMSText(patient_info, vaccines_info, pvs)
	 end
      end

      def getEmailText(patient_info, vaccines_info, pvs)
      end

      def getSMSText(patient_info, vaccines_info, pvs)
	    vaccine_list = ''
	    pvs.each do |v|
	       vaccine_list += vaccines_info[v.vaccine_id][:name] + ", "
	    end
	    fullMsg = "Dear #{patient_info[:first_name]}, you are scheduled for the vaccines(s) - #{vaccine_list}"
      end

   end

end
