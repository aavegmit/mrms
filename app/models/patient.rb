class Patient < ActiveRecord::Base
   validates :first_name, :presence => true
   validates :last_name, :presence => true
   validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

   after_destroy :cleanupVaccinations

   def cleanupVaccinations
      PatientVaccines.where(:patient_id => self.id).destroy_all
   end

   def vaccinate(vaccine_id, doseNum, date)
      vaccine = Vaccine.find(vaccine_id)
      if vaccine
	 pv = PatientVaccines.where(:patient_id => self.id,
				    :vaccine_id => vaccine_id,
				    :dose_number => doseNum).first_or_create
	 if date != '' and vaccine.nextDoseAfter(doseNum.to_i + 1)
	    nextDate = Date.parse(date) + vaccine.nextDoseAfter(doseNum.to_i + 1).to_i.week
	 else
	    nextDate = nil
	 end
	 pv.update_attributes({:vaccinated_on => date,
			       :next_dose_on   => nextDate })
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

end
