class AddPositionAndRemoveRoleAutorships < ActiveRecord::Migration
  def self.up
    remove_column :authorships, :author_kind
    
    
    add_column :authorships, :position, :integer
    add_column :editorships, :position, :integer
  end

  def self.down
    remove_column :editorships, :position
    remove_column :authorships, :position

    
    add_column :authorships, :author_kind, :string
  end
end
