class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :kind
      t.string :name
      t.text :intro
      t.integer :event_serie_id
    end
  end
  
  def self.down
    drop_table :events
  end
end
