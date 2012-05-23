class AddEventIdToPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :event_id, :string
  end

  def self.down
    remove_column :papers, :event_id
  end
end
