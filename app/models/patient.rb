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
				    :doseNumber => doseNum).first_or_create
	 if vaccine.nextDoseAfter(doseNum.to_i + 1)
	    nextDate = Date.parse(date) + vaccine.nextDoseAfter(doseNum.to_i + 1).to_i.month
	 else
	    nextDate = nil
	 end
	 pv.update_attributes({:vaccinatedOn => date,
			       :nextDoseOn   => nextDate })
      else
	 return false
      end
   end

   def vaccinesMap
      pv = PatientVaccines.where(:patient_id => self.id)
      map = {}
      pv.each do |record|
	 map[record[:vaccine_id]] = {} if map[record[:vaccine_id]].nil?
	 map[record[:vaccine_id]].merge!( { record[:doseNumber] => record[:vaccinatedOn]})
      end
      map
   end

end
