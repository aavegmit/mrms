require 'csv'

class WelcomeController < ApplicationController
   def index
   end

   def upload
      csv_text = File.read('./lib/input1.csv')
      dtp_id = Vaccine.find_by_name("DTP").id
      mmr_id = Vaccine.find_by_name("MMR").id
      bcg_id = Vaccine.find_by_name("BCG").id
      @csv = CSV.parse(csv_text, :headers => false)
      @csv.each do |row|
	 patient = Hash.new
	 patient[:doctor_id] = current_user.id
	 name = row[1].split(" ") unless row[1].nil?
	 patient[:first_name] = name[0] unless row[1].nil?
	 patient[:last_name] = name[1] unless name.nil? or name[1].nil?
	 patient[:address] = ''
	 patient[:address] += row[3] unless row[3].nil?
	 patient[:address] += ' ' + row[4] unless row[4].nil?
	 patient[:address] += ' ' + row[5] unless row[5].nil?
	 patient[:phone_number] = row[6] 
	 patient[:dob] = getDate(row[7]) unless row[7].nil?
	 unless row[1].nil?
	    @newPatient = Patient.create!(patient)
	    @newPatient.vaccinate(dtp_id,1, getDDMMdate(row[13])) unless row[13].nil?
	    @newPatient.vaccinate(dtp_id,2, getDDMMdate(row[14])) unless row[14].nil?
	    @newPatient.vaccinate(dtp_id,3, getDDMMdate(row[15])) unless row[15].nil?
	    @newPatient.vaccinate(mmr_id, 1, getDDMMdate(row[29] )) unless row[29].nil?
	    @newPatient.vaccinate(mmr_id, 2, getDDMMdate(row[30] )) unless row[30].nil?
	    @newPatient.vaccinate(bcg_id, 1, getDDMMdate(row[8])) unless row[8].nil?
	 end
      end
   end

   def uploadInfluenza
      csv_text = File.read('./lib/input2.csv')
      inf_id = Vaccine.find_by_name("Influenza").id
      @csv = CSV.parse(csv_text, :headers => false)
      @csv.each do |row|
	 patient = Hash.new
	 patient[:doctor_id] = current_user.id
	 patient[:rcn] = row[2] unless row[2].nil?
	 patient[:first_name] = row[3]
	 patient[:last_name] = row[4]
	 patient[:phone_number] = row[7] 
	 if row[6].nil?
	    patient[:dob] = Date.today - row[5].to_i.years unless row[5].nil?
	 else
	    patient[:dob] = getDDMMdate(row[6]) 
	 end
	 unless row[3].nil?
	    @newPatient = Patient.create!(patient)
	    @newPatient.vaccinate(inf_id,2, getDDMMdate(row[8])) unless getDDMMdate(row[8]).nil?
	    @newPatient.vaccinate(inf_id,3, getDDMMdate(row[9])) unless getDDMMdate(row[9]).nil?
	    @newPatient.vaccinate(inf_id,4, getDDMMdate(row[10])) unless getDDMMdate(row[10]).nil?
	    @newPatient.vaccinate(inf_id,5, getDDMMdate(row[11])) unless getDDMMdate(row[11]).nil?
	    @newPatient.vaccinate(inf_id,6, getDDMMdate(row[12])) unless getDDMMdate(row[12]).nil?
	 end
      end
   end

   private
   def getDate(dt)
      dob = dt.split("/") 
      if dob[2].size == 2
	 if dob[2].to_i > 20
	    newDob = dob[0] + "/" + dob[1] + "/19" + dob[2]
	 else
	    newDob = dob[0] + "/" + dob[1] + "/20" + dob[2]
	 end
	 return newDob
      else
	 return dt
      end
   end

   def getDDMMdate(dt)
      return nil if dt.nil?
      dob = dt.split("/") 
      return nil if dob.size != 3
      if dob[2].size == 2
	 if dob[2].to_i > 20
	    newDob = dob[1] + "/" + dob[0] + "/19" + dob[2]
	 else
	    newDob = dob[1] + "/" + dob[0] + "/20" + dob[2]
	 end
	 return newDob
      else
	 return dob[1] + "/" + dob[0] + "/" + dob[2]
      end
   end
end
