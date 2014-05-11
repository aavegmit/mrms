class ChangeCamelCaseTonormal < ActiveRecord::Migration
  def change
     rename_column :patient_vaccines, :nextDoseOn, :next_dose_on
  end
end
