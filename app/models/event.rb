class Event < ActiveRecord::Base
  attr_accessible :kind, :name, :intro
  
  KIND = {:acl => true, :non_acl => false}
  
  
  has_many :volumes
  has_many :sponsors
  belongs_to :event_series
  
end
