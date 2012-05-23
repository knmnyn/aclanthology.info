class AddDatasetToPaper < ActiveRecord::Migration
  def self.up
      add_column :papers, :dataset, :string

  end

  def self.down
      remove_column :papers, :dataset

  end
end
