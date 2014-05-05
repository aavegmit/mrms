class ChangeToDateTypes < ActiveRecord::Migration
  def change
     remove_column :patient_vaccines, :vaccinatedOn
     add_column :patient_vaccines, :vaccinatedOn, :date
  end
end
