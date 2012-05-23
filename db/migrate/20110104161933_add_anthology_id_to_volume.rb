class AddAnthologyIdToVolume < ActiveRecord::Migration
  def self.up
    add_column :volumes, :anthology_id, :string
  end

  def self.down
    remove_column :volumes, :anthology_id
  end
end
