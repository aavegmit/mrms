class AddNextDoseIsValidInPatientVaccine < ActiveRecord::Migration
  def change
     add_column :patient_vaccines, :is_next_dose_on_valid, :boolean
  end
end
