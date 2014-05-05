class ChangeDateTypeInDob < ActiveRecord::Migration
  def change
     remove_column :patients, :dob
     add_column :patients, :dob, :date
  end
end
