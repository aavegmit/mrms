module Reminder
   class << self

      def dailyReminder
	 pv = PatientVaccines.select("max(dose_number) as dose_num, patient_id, vaccine_id").where("next_dose_on > ?", Date.today).group("vaccine_id, patient_id").to_a
	 patient_id_map = pv.map {|u| u.patient_id}
	 patient_id_map.uniq!

	 vaccine_id_map = pv.map {|u| u.vaccine_id}
	 patients_info = Hash[Patient.select(:phone_number, :first_name, :last_name, :id).where(:id => patient_id_map).to_a.map {|u| [u.id, u]}]
	 vaccines_info = Hash[Vaccine.select(:name, :id).where(:id => vaccine_id_map).to_a.map {|u| [u.id, u]}]

	 pv.each do |item|
	    puts "Dear #{patients_info[item.patient_id][:first_name]}, you are scheduled to be vaccinated for #{vaccines_info[item.vaccine_id][:name]} dose number #{item.dose_num}"
	 end

      end

   end

end
