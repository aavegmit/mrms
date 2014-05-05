class CreateVaccines < ActiveRecord::Migration
  def change
    create_table :vaccines do |t|
       t.string :name
       t.integer :no_of_doses
       t.text :doses_gaps, :limit => nil

      t.timestamps
    end
  end
end
