class RenameColumnShortnamesToSigidInSiggroups < ActiveRecord::Migration
  def self.up
  rename_column :siggroups, :shortname, :sigid
  end

  def self.down
  rename_column :siggroups, :sigid, :shortname
  end
end
