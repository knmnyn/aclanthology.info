class AddAcronymToEventSeries < ActiveRecord::Migration
  def self.up
    add_column :event_series, :acronym, :string
  end

  def self.down
    remove_column :event_series, :acronym
  end
end
