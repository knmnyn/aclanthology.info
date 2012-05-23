class ChangeEventTypeToBoolean < ActiveRecord::Migration
  def self.up
    remove_column :events, :kind
    add_column :events, :kind, :boolean, :default => true
  end

  def self.down
    remove_column :events, :kind
    add_column :events, :kind, :string
  end
end
