class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.integer :paper_id
      t.string :url_type
      t.string :link

      t.timestamps
    end
  end

  def self.down
    drop_table :urls
  end
end
