class PatientVaccines < ActiveRecord::Base
   belongs_to :vaccine
   belongs_to :patient
end
