class Patient < ActiveRecord::Base
   include ::Reminder
   validates :first_name, :presence => true
  # validates :last_name, :presence => true
  # validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

   after_destroy :cleanupVaccinations
   after_create :addAgeBasedVaccines

   def addAgeBasedVaccines
      v_ids = Vaccine.getAgeBasedVaccines
      v_ids.each do |v_id|
	 self.vaccinate(v_id, "0", self.dob.strftime("%d-%m-%Y")) unless self.dob.nil?
      end
   end

   def cleanupVaccinations
      PatientVaccines.where(:patient_id => self.id).destroy_all
   end

   def dueDates
      Reminder.getAllDueReminders(self.id)
   end

   def vaccinate(vaccine_id, doseNum, date)
      vaccine = Vaccine.find(vaccine_id)
      isValid = false
      if vaccine
	 pv = PatientVaccines.where(:patient_id => self.id,
				    :vaccine_id => vaccine_id,
				    :doctor_id => self.doctor_id,
				    :dose_number => doseNum).first_or_create
	 if date != '' and vaccine.nextDoseAfter(doseNum.to_i + 1)
	    nextDate = Date.parse(date) + vaccine.nextDoseAfter(doseNum.to_i + 1).to_i.week
	    higherDosesCount = PatientVaccines.where("patient_id = ? and vaccine_id = ? and dose_number > ?", 
						     self.id, vaccine_id, doseNum).count
	    # This the highest dose, so set this is as valid
	    isValid = true if higherDosesCount == 0
	 else
	    # This is the last dose, so set valid to be false
	    nextDate = nil
	 end

	 # Always set the lower doses to be invalid
	 PatientVaccines.where("patient_id = ? and vaccine_id = ? and dose_number < ?", 
			       self.id, vaccine_id, doseNum).update_all(:is_next_dose_on_valid => false)
	 pv.update_attributes({:vaccinated_on => date,
			      :next_dose_on   => nextDate,
			      :is_next_dose_on_valid => isValid})
	 return nextDate
      else
	 return false
      end
   end

   def vaccinesMap
      pv = PatientVaccines.where(:patient_id => self.id)
      map = {}
      pv.each do |record|
	 map[record[:vaccine_id]] = {} if map[record[:vaccine_id]].nil?
	 map[record[:vaccine_id]].merge!( { record[:dose_number] => record[:vaccinated_on]})
      end
      map
   end

   def isUnderDoctor(doc_id)
      doctor_id == doc_id
   end

   def self.getForDoctor(doc_id)
      Patient.where(:doctor_id => doc_id)
   end


end
