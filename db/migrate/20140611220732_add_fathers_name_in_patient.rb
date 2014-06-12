class AddFathersNameInPatient < ActiveRecord::Migration
  def change
     add_column :patients, :fathers_name, :string
  end
end
