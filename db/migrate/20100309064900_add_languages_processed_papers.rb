class AddLanguagesProcessedPapers < ActiveRecord::Migration
  def self.up
    add_column :papers, :languages_processed, :string
  end

  def self.down
    remove_column :papers, :languages_processed
  end
end
