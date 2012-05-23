
require 'rexml/document'
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  def application_name
    "ACL Anthology"
  end
  def get_user_added_content fid
    file_path = File.expand_path "../../../user_content/"+fid+".xml", __FILE__
    if File.exist?(file_path)
      file = File.new file_path
      doc = REXML::Document.new file
      user_content={}
      doc.elements.each "paper/content" do |content|
        name = content.attributes["name"]
        user_content[name]=[]
        content.elements.each('item') do |item|
          user_content[name].push item.text
        end
        user_content[name].push content.attributes["type"]
      end
      user_content
    else
      user_content={}
    end
  end


end

