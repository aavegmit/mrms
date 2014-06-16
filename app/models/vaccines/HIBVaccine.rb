class HIBVaccine

#   def self.nextDoseDate(date, doseNum, age)
#      if(doseNum == 1)
#	 case age
#	 when 0..6
#	    return (Date.parse(date) + nextDoseAfter(doseNum, age).to_i.week)
#	 else
#	    return (Date.today + nextDoseAfter(doseNum, age).to_i.week)
#	 end
#      else
#	 return (Date.parse(date) + nextDoseAfter(doseNum, age).to_i.week)
#      end
#   end
   
   def self.nextDoseAfter(doseNum, age)
      case age
      when 0..6
	 case doseNum
	 when 1
	    6
	 when 2
	    4
	 when 3
	    4
	 when 4
	    38
	 end
      when 7..12
	 case doseNum
	 when 1
	    0
	 when 2
	    4
	 end
      when 13..15
	 case doseNum
	 when 1
	    0
	 when 2
	    (18-age)*4
	 end
      else
	 case doseNum
	 when 1
	    0
	 end
      end
   end

   def self.no_of_doses(age)
      case age
      when 0..6
	 3
      when 7..15
	 2
      else
	 1
      end
   end
end
