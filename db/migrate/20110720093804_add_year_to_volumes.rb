class AddYearToVolumes < ActiveRecord::Migration
  def self.up
      add_column :volumes, :year, :string
  end

  def self.down
      remove_column :volumes, :year
  end
end
