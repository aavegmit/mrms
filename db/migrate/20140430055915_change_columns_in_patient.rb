class ChangeColumnsInPatient < ActiveRecord::Migration
  def change
     rename_column :patients, :name, :first_name
     add_column :patients, :last_name, :string
  end
end
