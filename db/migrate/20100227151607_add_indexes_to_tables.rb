class AddIndexesToTables < ActiveRecord::Migration
  def self.up
    add_index :editorships, :person_id
    add_index :editorships, :volume_id
    add_index :authorships, :person_id
    add_index :authorships, :paper_id
    
    add_index :papers, :volume_id
  end

  def self.down
    remove_index :papers, :volume_id
    
    remove_index :authorships, :paper_id
    remove_index :authorships, :person_id
    remove_index :editorships, :volume_id
    remove_index :editorships, :person_id
  end
end
