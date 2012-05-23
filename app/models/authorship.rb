class Authorship < ActiveRecord::Base
  KINDS = {:author => 'author', :editor => 'editor'}
  
  belongs_to :paper
  belongs_to :person
  
  acts_as_list :scope => :paper
  # belongs_to :author, :class_name => "Person"
  # belongs_to :editor, :class_name => "Person"
  
end
