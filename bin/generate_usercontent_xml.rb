#!/usr/bin/ruby


#given a xml file of proceedings, generates xml for each paper under "user_content" dir

require 'rexml/document'

#acldoc = REXML::Document.new "jetty/min-test/with_bib_type/P11.xml"
aclfile = File.new ARGV[0]
acldoc = REXML::Document.new aclfile
volume_id= acldoc.root.attributes["id"]
acldoc.elements.each "volume/paper" do |paper|
  paper_id=volume_id+"-"+paper.attributes["id"]

  file= File.new "user_content/"+paper_id+".xml","w"
  doc = REXML::Document.new "<?xml version='1.0'?>"

  paper = doc.add_element 'paper'
  paper.attributes["id"]=paper_id
  content = paper.add_element 'content'
  content.attributes["type"] = "webpage"
  content.attributes["name"] = "aan_page"
  item = content.add_element "item"
  item.text = "http://clair.si.umich.edu/clair/anthology/query.cgi?type=Paper&id="+paper_id
  file.write doc.to_s
end
