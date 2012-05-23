class Volume < ActiveRecord::Base
  attr_accessible :year, :number, :title
  
  has_many :papers, :include => :authors
  has_many :editorships, :dependent => :destroy, :order => 'position'
  has_many :editors, :through => :editorships, :class_name => "Person", :source => :person
  
  belongs_to :event
  
  
  def year
    pubdate.year
  end
end
