class AddYearToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :year, :string
  end

  def self.down
    remove_column :papers, :year
  end
end
