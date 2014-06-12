class AddCatchupInVaccine < ActiveRecord::Migration
  def change
     add_column :vaccines, :catchup_in_weeks, :integer
  end
end
