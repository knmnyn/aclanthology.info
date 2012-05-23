class AddKindFieldToPaper < ActiveRecord::Migration
  def self.up
    add_column :papers, :kind, :string
  end

  def self.down
    remove_column :papers, :kind
  end
end
