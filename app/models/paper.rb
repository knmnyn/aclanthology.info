class Paper < ActiveRecord::Base
  default_scope :include => :authors
  
  attr_accessible :title, :pubdate, :address, :publisher, :url, :bibtype, :bibkey, :pages, :doi, :authors
  
  belongs_to :volume
  
  has_many :authorships, :dependent => :destroy, :order => 'position'
  has_many :authors, :through => :authorships, :class_name => "Person", :source => :person

  has_many :languages
  has_many :urls
  
  accepts_nested_attributes_for :authors
  
  validates_presence_of :title
  
  def to_oai_dc
    xml = Builder::XmlMarkup.new
    xml.tag!("oai_dc:dc",
    'xmlns:oai_dc' => "http://www.openarchives.org/OAI/2.0/oai_dc/",
    'xmlns:dc' => "http://purl.org/dc/elements/1.1/",
    'xmlns:xsi' => "http://www.w3.org/2001/XMLSchema-instance",
    'xsi:schemaLocation' =>
    %{http://www.openarchives.org/OAI/2.0/oai_dc/
      http://www.openarchives.org/OAI/2.0/oai_dc.xsd}) do
      xml.tag!('oai_dc:title', title)
      xml.tag!('oai_dc:description', "no description")
      xml.tag!('oai_dc:creator', authors_names)
      xml.tag!('oai_dc:subject', title)
      xml.tag!('oai_dc:type', kind)
      # xml.tag!('oai_dc:identifier', )
      # tags.each do |tag|
      #   xml.tag!('oai_dc:subject', tag)
      # end
    end
    xml.target!
  end
  
  def authors_names
    authors.collect(&:full_name).join("; ")
  end
  
  # def map_oai_dc
  #   {
  #      :subject => :title,
  #      # :subject => :tags,
  #      :description => 'no description',
  #      :creator => :authors_names,
  #      # :contibutor => :comments
  #   }
  # end
  
  # has_many :authors, 
  #          :through => :authorships, 
  #          :class_name => "Person",
  #          :source => :person,
  #          :conditions => ['authorships.author_kind = ?', Authorship::KINDS[:author]] do #role instead of author_kind
  #   def <<(author)
  #     Authorship.send(:with_scope, :create => {:author_kind => Authorship::KINDS[:author]}) { self.concat author}
  #   end
  # end
  # 
  # has_many :editors, 
  #          :through => :authorships, 
  #          :class_name => "Person",
  #          :source => :person,
  #          :conditions => ['authorships.author_kind = ?', Authorship::KINDS[:editor]] do
  #    def <<(editor)
  #      Authorship.send(:with_scope, :create => {:author_kind => Authorship::KINDS[:editor]}) { self.concat editor}
  #    end
  #  end
  def year
    pubdate.year
  end
end
