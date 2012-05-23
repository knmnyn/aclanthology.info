class CreateAuthorships < ActiveRecord::Migration
  def self.up
    create_table :authorships do |t|
      t.integer :paper_id
# changed by Min (Mon Dec 20 17:39:29 SGT 2010)
#      t.integer :author_id
      t.integer :person_id
      t.string :author_kind
    end
  end

  def self.down
    drop_table :authorships
  end
end
