class CreateEditorships < ActiveRecord::Migration
  def self.up
    create_table :editorships do |t|
      t.integer :volume_id
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :editorships
  end
end
