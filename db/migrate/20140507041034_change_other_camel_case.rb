class ChangeOtherCamelCase < ActiveRecord::Migration
  def change
     rename_column :patient_vaccines, :doseNumber, :dose_number
     rename_column :patient_vaccines, :vaccinatedOn, :vaccinated_on

  end
end
