class Editorship < ActiveRecord::Base
  belongs_to :person
  belongs_to :volume
  
  acts_as_list :scope => :volume
end
