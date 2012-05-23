class AddAnthologyIdToPaper < ActiveRecord::Migration
  def self.up
    add_column :papers, :anthology_id, :string
  end

  def self.down
    remove_column :papers, :anthology_id
  end
end
