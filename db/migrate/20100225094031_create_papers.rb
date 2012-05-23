class CreatePapers < ActiveRecord::Migration
  def self.up
    create_table :papers do |t|
      t.string :title
      t.datetime :pubdate
      t.string :address
      t.string :publisher
      t.string :url
      t.string :bibtype
      t.string :bibkey
      t.string :pages
      
      t.integer :volume_id
    end
  end
  
  def self.down
    drop_table :papers
  end
end
