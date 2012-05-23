class AddBibkeyToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :bibkey, :string
  end

  def self.down
    remove_column :events, :bibkey
  end
end
