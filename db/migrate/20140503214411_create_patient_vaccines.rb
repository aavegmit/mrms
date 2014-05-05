class CreatePatientVaccines < ActiveRecord::Migration
  def change
    create_table :patient_vaccines do |t|
      t.string :patient_id
      t.string :vaccine_id
      t.integer :doseNumber
      t.datetime :vaccinatedOn
      t.datetime :nextDoseOn

      t.timestamps
    end
  end
end
