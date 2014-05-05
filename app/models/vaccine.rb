class Vaccine < ActiveRecord::Base
   validates :name, :presence => true
   validate :doses_gaps_format

   after_destroy :destroyPatientVaccinations

   GAP_DELIM = "-"

   def destroyPatientVaccinations
      PatientVaccines.where(:vaccine_id => self.id).destroy_all
   end

   def nextDoseAfter(doseNum)
      if (doseNum > 1 and doseNum <= self.no_of_doses)
	 doses = self.doses_gaps.split("-")
	 return doses[doseNum - 2]
      else
	 return nil
      end
   end

   def self.maxDoses
      Vaccine.maximum(:no_of_doses)
   end

   private
   def doses_gaps_format
      if self.no_of_doses.nil? or self.no_of_doses < 1
	 errors.add(:no_of_doses, "should be atleast 1") 
	 return
      end
      formatStr = ("X-" * (self.no_of_doses - 1)).chop
      gaps = self.doses_gaps.split(GAP_DELIM)
      if (gaps.count != (self.no_of_doses - 1)) 
	 errors.add(:doses_gaps, ("should be of the format #{formatStr}, where X is a number "))
      else
	 gaps.each do |gap|
	    if (gap.to_i.to_s != gap)
	       errors.add(:doses_gaps, ("should be of the format #{formatStr}, where X is a number"))
	    end
	 end
      end

   end
end
