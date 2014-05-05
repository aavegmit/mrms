class ChangeIdsToInteger < ActiveRecord::Migration
  def change
     remove_column :patient_vaccines, :patient_id
     remove_column :patient_vaccines, :vaccine_id
     add_column :patient_vaccines, :patient_id, :integer
     add_column :patient_vaccines, :vaccine_id, :integer
  end
end
