class BCGVaccine

#   def self.nextDoseDate(date, doseNum, age)
#      return nil if nextDoseAfter(doseNum, age).nil?
#      return (Date.today + nextDoseAfter(doseNum, age).to_i.week)
#   end

   def self.nextDoseAfter(doseNum, age)
      return nil if no_of_doses(age) < doseNum
      0
   end

   def self.no_of_doses(age)
      1
   end
   
end
