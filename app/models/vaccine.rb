class Vaccine < ActiveRecord::Base
   validates :name, :presence => true
   validate :doses_gaps_format

   after_destroy :destroyPatientVaccinations

   GAP_DELIM = "-"

   def destroyPatientVaccinations
      PatientVaccines.where(:vaccine_id => self.id).destroy_all
   end

   # After how may weeks would you get "doseNum"
   def nextDoseAfter(doseNum)
      doses = self.doses_gaps.split(GAP_DELIM)
      return nil if doseNum <= 0

      if doses[0] == 'R'
	 if doses[doseNum].nil?
	    return doses[-1]
	 else
	    return doses[doseNum]
	 end
      else
	 if (doseNum <= self.no_of_doses)
	    doses = self.doses_gaps.split("-")
	    return doses[doseNum]
	 else
	    return nil
	 end
      end
   end

   def self.maxDoses
      Vaccine.maximum(:no_of_doses)
   end

   def self.getAgeBasedVaccines
      ageVacc = Vaccine.select(:id).where("doses_gaps like ?", 'A%')
      ageVacc.map {|v| v.id}
   end

   private
   def doses_gaps_format
      gaps = self.doses_gaps.split(GAP_DELIM)
      if gaps[0] == 'R'
      else
	 if self.no_of_doses.nil? or self.no_of_doses < 1
	    errors.add(:no_of_doses, "should be atleast 1") 
	    return
	 end
	 formatStr = "A/C-" + ("X-" * (self.no_of_doses)).chop
	 if (gaps.count != (self.no_of_doses + 1)) 
	    errors.add(:doses_gaps, ("should be of the format #{formatStr}, where X is the number of weeks "))
	    return
	 end

	 if !(gaps[0] == 'A' || gaps[0] == 'C')
	    errors.add(:doses_gaps, ("should start with A for age related vaccines, or C for non-age related vaccines"))
	    return
	 end
	 gaps.shift
	 gaps.each do |gap|
	    if (gap.to_i.to_s != gap)
	       errors.add(:doses_gaps, ("should be of the format #{formatStr}, where X is a number of weeks"))
	       return
	    end
	 end
      end

   end
end
