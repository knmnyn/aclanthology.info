class ChangeColumnVolumeIdInPapers < ActiveRecord::Migration
  def self.up
   change_column :papers, :volume_id , :string
  end

  def self.down
   change_column :papers, :volume_id , :integer
  end
end
