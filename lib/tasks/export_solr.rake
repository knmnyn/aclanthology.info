namespace :anthology do
  desc "Export papers from database into solr via xml file"
  task :export_to_solr => :environment do
    xml = REXML::Document.new "<?xml version='1.0'?>"
    post_loc = "../jetty/post.sh"
    require 'tempfile'
    papers = Paper.find(:all)
    add = xml.add_element 'add'
    papers.each { |paper|

      doc = add.add_element 'doc'
      id = doc.add_element 'field'
      year = doc.add_element 'field'
      title = doc.add_element 'field'
      venue = doc.add_element 'field'
      acmdoi  = doc.add_element 'field'
      event_type  = doc.add_element 'field'
      siginfo  = doc.add_element 'field'
      volumeinfo  = doc.add_element 'field'
      volumeid  = doc.add_element 'field'
      pdflink = doc.add_element 'field'
      dataset = doc.add_element 'field'
      software = doc.add_element 'field'
      attachment = doc.add_element 'field'
      bibformat = doc.add_element 'field'
      risformat = doc.add_element 'field'
      endformat = doc.add_element 'field'
      wordformat = doc.add_element 'field'

      id.attributes["name"] = "id"
      title.attributes["name"] = "title"
      year.attributes["name"] = "year"
      venue.attributes["name"] = "venue"
      acmdoi.attributes["name"] = "acmdoi"
      event_type.attributes["name"] = "event_type"
      siginfo.attributes["name"] = "siginfo"
      volumeinfo.attributes["name"] = "volumeinfo"
      volumeid.attributes["name"] = "volumeid"
      pdflink.attributes["name"] = "pdflink"
      bibformat.attributes["name"] = "bibformat"
      risformat.attributes["name"] = "risformat"
      endformat.attributes["name"] = "endformat"
      wordformat.attributes["name"]="wordformat"
      dataset.attributes["name"] = "dataset"
      software.attributes["name"] = "software"
      attachment.attributes["name"] = "attachment"


      puts paper.anthology_id

      if paper.doi
          acmdoi.text ="#{paper.doi}"
      else
        acmdoi.text = "not available"
      end
      

      id.text = paper.anthology_id
      title.text =  paper.title
      year.text = paper.year
      venuelabel=paper.anthology_id[0..0]
      

      acmurl= "http://aclweb.org/anthology-new/"
      
      volumeinfo.text =' '
      if paper.volume != nil
        siginfo.text = paper.volume.sigid
        volumeinfo.text = paper.volume.title
        volumeid.text = paper.volume.anthology_id
      end

      if not paper.anthology_id[0..2] == "L10"
        pdflink.text = acmurl+paper.anthology_id[0..0]+"/"+paper.anthology_id[0..2]+"/"+paper.anthology_id+".pdf"
      else
        pdflink.text = paper.url
      end
      #biblink.text = acmurl+paper.anthology_id[0..0]+"/"+paper.anthology_id[0..2]+"/"+paper.anthology_id+".bib"
    
      
      attachments = doc.add_element 'field'
      attachments.attributes["name"] = "attachments"
      attachments.text = "none"

      if paper.software 
        software.text = "http://aclweb.org/supplementals/"+paper.anthology_id[0..0]+"/"+paper.anthology_id[0..2]+"/"+paper.software
        attachments.text = "Software"
      else
        software.text = "not available"
      end

      if paper.attachment 
        attachment.text = "http://aclweb.org/supplementals/"+paper.anthology_id[0..0]+"/"+paper.anthology_id[0..2]+"/"+paper.attachment
        attachments.text = "Attachment"
      else
        attachment.text = "not available"
      end

      if paper.dataset 
        dataset.text  = "http://aclweb.org/supplementals/"+paper.anthology_id[0..0]+"/"+paper.anthology_id[0..2]+"/"+paper.dataset
        attachments.text = "Dataset"
      else
        dataset.text = "not available"
      end


      #type.text = "InProceedings" # TODO fix this
      workshop_labels= get_workshop_labels

      case venuelabel
		when "A"
		 venue.text="ANLP"	
         event_type.text="ACL"
		when "D"
		 venue.text="EMNLP"
         event_type.text="ACL"
		when "E"
		 venue.text="EACL"
         event_type.text="ACL"
		when "N"
		 venue.text="NAACL"
         event_type.text="ACL"
		when "S"
		 venue.text="SEMEVAL"
         event_type.text="ACL"
		when "J"
		 venue.text="CL"
         event_type.text="ACL"
		when "P"
		 venue.text="ACL"
         event_type.text="ACL"
		when "C"
		 venue.text="COLING"
         event_type.text="Non ACL"
		when "H"
		 venue.text="HLT"
         event_type.text="Non ACL"
		when "I"
		 venue.text="IJCNLP"
         event_type.text="Non ACL"
		when "L"
		 venue.text="LREC"
         event_type.text="Non ACL"
		when "U"
		 venue.text="ALTA"
         event_type.text="Non ACL"
		when "R"
		 venue.text="RANLP"
         event_type.text="Non ACL"
		when "T"
		 venue.text= "TINLAP"
         event_type.text="Non ACL"
		when "M"
		  venue.text="MUC"
         event_type.text="Non ACL"
		when "Y"
		 venue.text="PACLIC"
         event_type.text="Non ACL"
		when "O"
		 venue.text="ROCLING"
         event_type.text="Non ACL"
		when "X"
		 venue.text="TIPSTER"
         event_type.text="Non ACL"
        when "W"
          volume_id = paper.anthology_id[0..-3]+"00"
          if workshop_labels.has_key?(volume_id)
    		  venue.text= workshop_labels[volume_id].downcase
          else
            venue.text = "Others"
          end
         event_type.text="Non ACL"
     end

      citation_text= ''

      paper.authors.each { |author|
        author_elt = doc.add_element 'field'
        author_elt.attributes["name"] = "author"

        author_lastname = doc.add_element 'field'
        author_lastname.attributes["name"] = "author_lastname"

        first_name=" "
        last_name=" "
        if author.first_name
                first_name=author.first_name
        end
        if author.last_name
                last_name=author.last_name
        end
        author_elt.text = " "+first_name + " " + last_name+" "
        author_lastname.text = " "+last_name + " " + first_name+" "
        if citation_text == ''
          citation_text = first_name+" "+last_name
        else  
          citation_text = citation_text+", " +first_name+" "+last_name
        end
#	author_elt.text = author.last_name + ", " + author.first_name
      }
        mods_xml= generate_modsxml title.text,year.text,volumeinfo.text,paper.authors
        file = File.new('BiblioScript/bibutils_3.40/mods.xml','w')
        file.write mods_xml
        file.close
        bib=`BiblioScript/bibutils_3.40/xml2bib BiblioScript/bibutils_3.40/mods.xml`
        ris=`BiblioScript/bibutils_3.40/xml2ris BiblioScript/bibutils_3.40/mods.xml`
        endf =`BiblioScript/bibutils_3.40/xml2end BiblioScript/bibutils_3.40/mods.xml`
        word=`BiblioScript/bibutils_3.40/xml2wordbib BiblioScript/bibutils_3.40/mods.xml`
        ris=validate_encoding(ris, :invalid => :replace, :replace => "")
        endf=validate_encoding(endf, :invalid => :replace, :replace => "")
        bib=validate_encoding(bib, :invalid => :replace, :replace => "")
        word=validate_encoding(word, :invalid => :replace, :replace => "")

        bibformat.text = bib
        risformat.text = ris
        endformat.text = endf
        wordformat.text = word
    }


    # write xml doc to temporary file
    file = File.new('anthology_solr_dump','w')
    file.write xml.to_s
    puts file.path
    #file.rewind
    file.close

    puts `#{post_loc} #{file.path}`
    # ingest file
    #`#{post_loc} #{file.path}`
    #file.unlink
  end

  def get_workshop_labels 
  
  volume_mappings= {}
  file = File.new('doc/workshop_categories.txt','r')
  lines = file.readlines
  lines.each do  |line|
    parts= line.split(":")
    acronym = parts[0]
    volumes= parts[1].split(",")
    volumes.each do |vol|
      volume_mappings[vol.strip]= acronym
    end
  end
  return volume_mappings
 end

 def generate_modsxml paper_title,year,volume_title,authors
      xml = REXML::Document.new "<?xml version='1.0'?>"
      mods=xml.add_element 'mods'
      mods.attributes["ID"]='d1ej'
      title_info = mods.add_element 'titleInfo'
      title_name = title_info.add_element 'title'
      title_name.text = paper_title
      authors.each { |author|
        name = mods.add_element 'name'
        name.attributes["type"]="personal"
        
        name_part_first = name.add_element 'namePart'
        name_part_first.attributes["type"]="given"
        name_part_first.text = author.first_name

        name_part_last = name.add_element 'namePart'
        name_part_last.attributes["type"]="family"
        name_part_last.text = author.last_name

        role = name.add_element 'role'
        roleterm = role.add_element 'roleTerm'
        roleterm.attributes["authority"]="marcrelator"
        roleterm.attributes["type"]="text"
        roleterm.text="author"

      }
     origin_info = mods.add_element 'originInfo'
     date_issued = origin_info.add_element 'dateIssued'
     date_issued.text = year
     
     genre_type = mods.add_element 'genre'
     genre_type.text = "conference publication"

     related_item = mods.add_element 'relatedItem'
     related_item.attributes["type"]="host"
     volume_info = related_item.add_element 'titleInfo'
     volume_name = volume_info.add_element 'title'
     volume_name.text = volume_title

    return xml.to_s
 end

 def generate_volume_modsxml paper_title,year,authors
      xml = REXML::Document.new "<?xml version='1.0'?>"
      mods=xml.add_element 'mods'
      mods.attributes["ID"]='d1ej'
      title_info = mods.add_element 'titleInfo'
      title_name = title_info.add_element 'title'
      title_name.text = paper_title
#add author information
      authors.each { |author|
        name = mods.add_element 'name'
        name.attributes["type"]="personal"
        
        name_part_first = name.add_element 'namePart'
        name_part_first.attributes["type"]="given"
        name_part_first.text = author.first_name

        name_part_last = name.add_element 'namePart'
        name_part_last.attributes["type"]="family"
        name_part_last.text = author.last_name

        role = name.add_element 'role'
        roleterm = role.add_element 'roleTerm'
        roleterm.attributes["authority"]="marcrelator"
        roleterm.attributes["type"]="text"
        roleterm.text="editor"

      }
     origin_info = mods.add_element 'originInfo'
     date_issued = origin_info.add_element 'dateIssued'
     date_issued.text = year
     
    return xml.to_s
 end
##############################################################################################################################################

  desc "Export papers from database into solr via xml file"
  task :export_volume_to_solr => :environment do
    xml = REXML::Document.new "<?xml version='1.0'?>"
    post_loc = "../jetty/post.sh"
    require 'tempfile'
	#Volume.delete_all(:anthology_id => "W00-0700") #index again and remove this 
    volumes = Volume.find(:all)

    add = xml.add_element 'add'
    volumes.each { |volume|
      doc = add.add_element 'doc'
      id = doc.add_element 'field'
      type = doc.add_element 'field'
      title = doc.add_element 'field'
      year = doc.add_element 'field'
      venue = doc.add_element 'field'
      event_type  = doc.add_element 'field'
      siginfo  = doc.add_element 'field'
      volumeinfo  = doc.add_element 'field'
      volumeid  = doc.add_element 'field'
      pdflink = doc.add_element 'field'
      bibformat = doc.add_element 'field'
      risformat = doc.add_element 'field'
      endformat = doc.add_element 'field'
      wordformat = doc.add_element 'field'


      id.attributes["name"] = "id"
      type.attributes["name"] = "type"
      title.attributes["name"] = "title"
      year.attributes["name"] = "year"
      venue.attributes["name"] = "venue"
      event_type.attributes["name"] = "event_type"
      siginfo.attributes["name"] = "siginfo"
      volumeinfo.attributes["name"] = "volumeinfo"
      volumeid.attributes["name"] = "volumeid"
      pdflink.attributes["name"] = "pdflink"
      bibformat.attributes["name"] = "bibformat"
      risformat.attributes["name"] = "risformat"
      endformat.attributes["name"] = "endformat"
      wordformat.attributes["name"] = "wordformat"


      id.text = volume.anthology_id
      type.text = "Volume" # TODO fix this

      puts volume.anthology_id
      puts volume.title
      title.text =  volume.title
      volumeinfo.text = volume.title 
      volumeid.text = volume.anthology_id
      siginfo.text = volume.sigid if volume.sigid
      year.text = volume.year 

      venuelabel=volume.anthology_id[0..0]
      acmurl= "http://aclweb.org/anthology-new/"
      pdflink.text = acmurl+volume.anthology_id[0..0]+"/"+volume.anthology_id[0..2]+"/"+volume.anthology_id+".pdf"
      #biblink.text = acmurl+volume.anthology_id[0..0]+"/"+volume.anthology_id[0..2]+"/"+volume.anthology_id+".bib"

      workshop_labels = get_workshop_labels
      case venuelabel
		when "A"
		 venue.text="ANLP"	
         event_type.text="ACL"
		when "D"
		 venue.text="EMNLP"
         event_type.text="ACL"
		when "E"
		 venue.text="EACL"
         event_type.text="ACL"
		when "N"
		 venue.text="NAACL"
         event_type.text="ACL"
		when "S"
		 venue.text="SEMEVAL"
         event_type.text="ACL"
		when "J"
		 venue.text="CL"
         event_type.text="ACL"
		when "P"
		 venue.text="ACL"
         event_type.text="ACL"
		when "C"
		 venue.text="COLING"
         event_type.text="Non ACL"
		when "H"
		 venue.text="HLT"
         event_type.text="Non ACL"
		when "I"
		 venue.text="IJCNLP"
         event_type.text="Non ACL"
		when "L"
		 venue.text="LREC"
         event_type.text="Non ACL"
		when "U"
		 venue.text="ALTA"
         event_type.text="Non ACL"
		when "R"
		 venue.text="RANLP"
         event_type.text="Non ACL"
		when "T"
		 venue.text= "TINLAP"
         event_type.text="Non ACL"
		when "M"
		  venue.text="MUC"
         event_type.text="Non ACL"
		when "Y"
		 venue.text="PACLIC"
         event_type.text="Non ACL"
		when "O"
		 venue.text="ROCLING"
         event_type.text="Non ACL"
		when "X"
		 venue.text="TIPSTER"
         event_type.text="Non ACL"
       when "W"
         volume_id = volume.anthology_id
         if workshop_labels.has_key?(volume_id)
           venue.text= workshop_labels[volume_id].downcase
         else
           venue.text = "Others"
         end
         event_type.text="Non ACL"

     end

      citation_text= ''
    
      volume.editors.each { |author|
        author_elt = doc.add_element 'field'
        author_elt.attributes["name"] = "author"

        first_name=" "
        last_name=" "
        if author.first_name
                first_name=author.first_name
        end
        if author.last_name
                last_name=author.last_name
        end
        author_elt.text = " "+first_name + " " + last_name+" "
        
        if citation_text == ''
          citation_text = first_name+" "+last_name
        else  
          citation_text = citation_text+", " +first_name+" "+last_name
        end
#	author_elt.text = author.last_name + ", " + author.first_name
      }


        mods_xml= generate_volume_modsxml title.text,year.text,volume.editors
        file = File.new('BiblioScript/bibutils_3.40/mods.xml','w')
        file.write mods_xml
        file.close
        bib=`BiblioScript/bibutils_3.40/xml2bib BiblioScript/bibutils_3.40/mods.xml`
        ris=`BiblioScript/bibutils_3.40/xml2ris BiblioScript/bibutils_3.40/mods.xml`
        endf =`BiblioScript/bibutils_3.40/xml2end BiblioScript/bibutils_3.40/mods.xml`
        word=`BiblioScript/bibutils_3.40/xml2wordbib BiblioScript/bibutils_3.40/mods.xml`
	ris=validate_encoding(ris, :invalid => :replace, :replace => "")
        endf=validate_encoding(endf, :invalid => :replace, :replace => "")
        bib=validate_encoding(bib, :invalid => :replace, :replace => "")
        word=validate_encoding(word, :invalid => :replace, :replace => "")

        bibformat.text = bib
        risformat.text = ris
        endformat.text = endf
        wordformat.text = word

   }	
    # write xml doc to temporary file
    file = File.new('anthology_solr_vol_dump','w')
    file.write xml.to_s
    #file.rewind
    file.close

    # ingest file
    puts `#{post_loc} #{file.path}`
    #file.unlink
  end

  def validate_encoding(str, options = {})
        str.chars.collect do |c|
        if c.valid_encoding?
        c
        else
        unless options[:invalid] == :replace
        raise  Encoding::InvalidByteSequenceError.new
        else
        options[:replace] || (
                        str.encoding.name.start_with?('UTF') ?
                        "\uFFFD" :
                        "?" )
        end
        end
        end.join
 end

end # namespace :anthology
