class AddColumSiggroupToVolume < ActiveRecord::Migration
  def self.up
  add_column :volumes, :sigid, :string
  end

  def self.down
  remove_column :volumes, :sigid
  end
end
