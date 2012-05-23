class CreateVolumes < ActiveRecord::Migration
  def self.up
    create_table :volumes do |t|
      t.integer :year
      t.string :number
      t.string :title
      
      t.integer :event_id
    end
  end
  
  def self.down
    drop_table :volumes
  end
end
