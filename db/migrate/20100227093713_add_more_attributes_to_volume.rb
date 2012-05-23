class AddMoreAttributesToVolume < ActiveRecord::Migration
  def self.up
    add_column :volumes, :address, :string
    add_column :volumes, :pubdate, :date
    add_column :volumes, :publisher, :string
    add_column :volumes, :url, :string
    add_column :volumes, :bibtype, :string
    add_column :volumes, :bibkey, :string
  end

  def self.down
    remove_column :volumes, :bibkey
    remove_column :volumes, :bibtype
    remove_column :volumes, :url
    remove_column :volumes, :publisher
    remove_column :volumes, :pubdate
    remove_column :volumes, :address
  end
end
