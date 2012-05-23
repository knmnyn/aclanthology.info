class AddAcmsearchToPaper < ActiveRecord::Migration
  def self.up
    add_column :papers, :acmsearch, :string
  end

  def self.down
    remove_column :papers, :acmsearch
  end
end
