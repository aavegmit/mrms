class AddDoctorIdInPatientVaccines < ActiveRecord::Migration
  def change
     add_column :patient_vaccines, :doctor_id, :integer
  end
end
