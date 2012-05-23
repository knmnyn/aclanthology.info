class RemoveYearFromVolume < ActiveRecord::Migration
  def self.up
    remove_column :volumes, :year
  end

  def self.down
    add_column :volumes, :year, :integer
  end
end
