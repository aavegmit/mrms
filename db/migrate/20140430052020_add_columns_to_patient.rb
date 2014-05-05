class AddColumnsToPatient < ActiveRecord::Migration
  def change
     add_column :patients, :name, :string
     add_column :patients, :email, :string
     add_column :patients, :phone_number, :string
     add_column :patients, :address, :text, :limit => nil
     add_column :patients, :dob, :datetime
  end
end
