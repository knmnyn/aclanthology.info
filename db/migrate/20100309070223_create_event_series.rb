class CreateEventSeries < ActiveRecord::Migration
  def self.up
    create_table :event_series do |t|
    end
  end

  def self.down
    drop_table :event_series
  end
end
