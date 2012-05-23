class AddAttachmentToPaper < ActiveRecord::Migration
  def self.up
    add_column :papers, :attachment, :string
  end

  def self.down
  remove_column :papers, :attachment
  end
end
