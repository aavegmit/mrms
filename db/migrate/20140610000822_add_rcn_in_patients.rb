class AddRcnInPatients < ActiveRecord::Migration
  def change
     add_column :patients, :rcn, :integer
  end
end
