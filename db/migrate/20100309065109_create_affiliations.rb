class CreateAffiliations < ActiveRecord::Migration
  def self.up
    create_table :affiliations do |t|
      t.integer :person_id
      t.string :institution
      t.date :start_date
      t.date :end_date
      t.string :position
    end
  end

  def self.down
    drop_table :affiliations
  end
end
