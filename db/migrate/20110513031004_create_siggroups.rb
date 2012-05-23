class CreateSiggroups < ActiveRecord::Migration
  def self.up
    create_table :siggroups do |t|
      t.string :name
      t.string :shortname
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :siggroups
  end
end
