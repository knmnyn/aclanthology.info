class AddSoftwareToPaper < ActiveRecord::Migration
  def self.up
      add_column :papers, :software, :string

  end

  def self.down
      remove_column :papers, :software

  end
end
