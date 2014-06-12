class DTPVaccine

   def self.nextDoseAfter(doseNum, age)
      if(age > 48)
	 case doseNum
	 when 1
	    0
	 when 2
	    4
	 when 3
	    20
	 else
	 end
      else
	 case doseNum
	 when 1
	    6
	 when 2
	    4
	 when 3
	    4
	 when 4
	    50
	 when 5
	    144
	 else
	    nil
	 end
      end
   end

   def self.no_of_doses(age)
      if(age > 48)
	 3
      else
	 5
      end
   end

end
