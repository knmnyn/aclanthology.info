class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name,:papers
  
  has_many :authorships, :dependent => :destroy
  has_many :papers, :through => :authorships
  has_many :editorships, :dependent => :destroy
  has_many :volumes, :through => :editorships
  
  has_many :affiliations, :dependent => :destroy
  accepts_nested_attributes_for :affiliations, :allow_destroy => true
  validates_associated :affiliations
  
  def full_name
    [first_name, last_name].join(" ")
  end
end
