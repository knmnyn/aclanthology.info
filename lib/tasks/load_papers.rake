namespace :anthology do

  desc "Loads papers from an xml file specified by xml_file environment variable"
  task :load_papers => :environment do 
    file = File.new ENV["xml_file"] 
    doc = REXML::Document.new file
    
    # Get the information about the volumes first
    # i.e. papers which have <bibtype>book</bibtype>
    # Each paper will then belong to a volume;
    # we can match that by <booktitle> </booktitle> field.

     #Processing Event Information
     @g_event = Event.new
     doc.elements.each "volume/paper[bibtype='book']" do |event|
        if event.attributes['id'] == '1000'
           @g_event.name= event.elements['title'].text
           @g_event.bibkey = event.elements['bibkey'].text
           @g_event.event_id = event.elements['url'].text.split(/\//)[-1]
        end
     end

    #Processing Volumes 
    volume_label = doc.elements.each("volume") { |element| puts element.attributes["id"] }
    doc.elements.each("volume") { |elem| 
	$volume_label= elem.attributes["id"] 
	}
    doc.elements.each("volume/paper[bibtype='book']") do |paper| 
      puts "Volume title: #{paper.elements['title'].text}"
      @volume = Volume.new
      @volume.url       = paper.elements['url'].text

      if not Volume.find_by_anthology_id @volume.anthology_id #for unique anthology_id check to prevent replication while loading xml
        @volume.title = paper.elements['title'].text
        month            = paper.elements['month'].text
        year             = paper.elements['year'].text
        if year
          @volume.year      = year
        else
  	        year= $volume_label.slice 1,2 
	    	if year.to_i > 50
		    	year="19"+year
    		else
	    		year="20"+year
		    end

        end
        if paper.elements['url']
          @volume.anthology_id = paper.elements['url'].text.split(/\//)[-1]
        else 
	        @volume.anthology_id =$volume_label+'-'+ paper.attributes["id"]
        end
        @volume.pubdate   = DateTime.parse("#{month} #{year}")
      
        #No events for Workshop papers
        if not @volume.anthology_id.start_with? 'W'
           @volume.event = @g_event
          #puts "Event Name: #{@volume.event.name}"
        end

        @volume.save
        # save editors
        paper.elements.each('editor') do |editor|
          if editor.elements['first']
            first_name = editor.elements['first'].text 
          else
            first_name = ""
          end
          if editor.elements['last']
            last_name = editor.elements['last'].text
          else
            last_name = ""
          end
          if first_name == "" and last_name == ""
            first_name = editor.text
          end
          @editor    = Person.find_or_create_by_first_name_and_last_name(first_name, last_name)
          @volume.editors << @editor
        end
      end
     end 
    #puts "Papers..."
    doc.elements.each("volume/paper[bibtype!='book']") do |paper| 
      
      volume_title  = paper.elements['booktitle'].text
      @volume       = Volume.find_by_title(volume_title)

      @paper        = Paper.new
      @paper.url       = paper.elements['url'].text
      @paper.anthology_id = paper.elements['url'].text.split(/\//)[-1]

      if not Paper.find_by_anthology_id @paper.anthology_id #for unique anthology_id check to prevent replication while loading xml
      
      @paper.volume = @volume     
      @paper.title  = paper.elements['title'].text      
      #puts @paper.title
      month            = paper.elements['month'].text
      year             = paper.elements['year'].text
      @paper.year      = year
      @paper.pubdate   = DateTime.parse("#{month} #{year}")
      @paper.address   = paper.elements['address'].text
      @paper.publisher = paper.elements['publisher'].text if paper.elements['publisher']
      @paper.pages     = paper.elements['pages'].text
      @paper.bibtype   = paper.elements['bibtype'].text
      @paper.bibkey    = paper.elements['bibkey'].text
      @paper.dataset    = paper.elements['dataset'].text if paper.elements['dataset']
      @paper.software   = paper.elements['software'].text  if paper.elements['software']
      @paper.attachment   = paper.elements['attachment'].text  if paper.elements['attachment']
      #@paper.acmsearch = @paper.title.downcase.strip
     
      #to search titles in acm metadata files
      l_acmsearch=@paper.title.downcase.strip
      l_acmsearch=l_acmsearch.gsub /[:-]/,' ' 
      l_acmsearch=l_acmsearch.gsub '  ',' ' 
      @paper.acmsearch = l_acmsearch

      @paper.save #author information is replicated if placed later!!!
       #puts "#{@paper.anthology_id}, #{@paper.volume.anthology_id} #{@paper.volume.event.event_id}"
      # puts @paper.acmsearch

      # save authors
      l_authors=''
      paper.elements.each('author') do |author|
        if author.elements['first']
          first_name = author.elements['first'].text 
        else
          first_name = ""
        end
        if author.elements['last']
          last_name = author.elements['last'].text
        else
          last_name = ""
        end

	# added by min (Fri Dec 31 14:54:48 SGT 2010) - parse older files
    	if first_name == '' and last_name == '' 
	      if / /.match(author.text) 
	         author_elts = author.text.split(/ /)
	         last_name = author_elts[-1]
	        first_name = author_elts[0..-2].join(" ")
          else 
  	        last_name = author.text
          end
        end
        
        @author    = Person.find_or_create_by_first_name_and_last_name(first_name, last_name)
        #use author information to distinguish when two titles match in acm metadata
        l_authors ="#{l_authors}__#{first_name}_#{last_name}"
        @paper.authors << @author
      end
      
      #@paper.acmsearch = l_acmsearch+l_authors.downcase.strip
     end #for the unique paper.anthology_id 
   end  #for each paper
 end  #for task

desc "Loads papers from an xml files without <bibtype> and <bibtitle>"
 #load_papers with no <bibtype> and <bibtitle> 
  task :load_papers_withoutbib => :environment do 
    file = File.new ENV["xml_file"] 
    doc = REXML::Document.new file
   
    doc.elements.each("volume") { |elem| 
	$volume_label= elem.attributes["id"] 
	}
    #Processing Events
    
    @g_event = Event.new
    doc.elements.each("volume/paper") do |paper| 
        if paper.attributes['id'] == '1000'
          @g_event.name= paper.elements['title'].text
	      @g_event.event_id =$volume_label+'-'+ paper.attributes["id"]
        end

    end
    #Processing Volumes and papers
    doc.elements.each("volume/paper") do |paper| 
      #Intution that volume titles end with "00" and doesn't have "author"
      if not paper.elements['author']
	    vol_id =$volume_label+'-'+ paper.attributes["id"]
        
        if paper.attributes["id"].end_with? "00"     
            #@volume = Volume.new
	        #@volume.anthology_id =$volume_label+'-'+ paper.attributes["id"]
          if not Volume.find_by_anthology_id vol_id #for unique anthology_id check
            @volume = Volume.new
          	@volume.title = paper.elements['title'].text
	        @volume.anthology_id =vol_id
  	        year= $volume_label.slice 1,2 
  	    	month="march"
	    	if year.to_i > 50
		    	year="19"+year
    		else
	    		year="20"+year
		    end
            @volume.year      = year
	        @volume.pubdate = DateTime.parse ("#{month} #{year}")
            @volume.save
            @volume.event = @g_event
         else
           @volume = Volume.find_by_anthology_id vol_id
            @volume.save
          end
      end
      else
	      @paper        = Paper.new
	      @paper.title  = paper.elements['title'].text      
          @paper.doi = paper.elements['doi'].text if paper.elements['doi']
	      @paper.anthology_id =$volume_label+'-'+ paper.attributes["id"]
          if $volume_label == "L10"
            @paper.url = paper.attributes["href"]
          end
          if not Paper.find_by_anthology_id @paper.anthology_id #for unique anthology_id check
		
	       year= $volume_label.slice 1,2 
	    	month="march"
	    	if year.to_i > 50
		    	year="19"+year
    		else
	    		year="20"+year
		    end
            @paper.year = year
	        @paper.pubdate = DateTime.parse ("#{month} #{year}")
	        venue =$volume_label.slice 0,1
      #to search titles in acm metadata files
         l_acmsearch=@paper.title.downcase.strip
         l_acmsearch=l_acmsearch.gsub /[:-]/,'' 
         l_acmsearch=l_acmsearch.gsub '  ',' ' 
         @paper.acmsearch = l_acmsearch
	     @paper.volume = @volume
         @paper.save

    	   # save authors
	        l_authors=''
            paper.elements.each('author') do |author|
	    	  if author.elements['first']
		       first_name = author.elements['first'].text 
    		  else
	    	   first_name = ""
		      end
    		  if author.elements['last']
	    	    last_name = author.elements['last'].text
		      else
		        last_name = ""
		      end
	   	   
        	# added by min (Fri Dec 31 14:54:48 SGT 2010) - parse older files
	    	  if first_name == '' and last_name == '' 
     	    	 # paper.elements.each('author') do |author|
		        if / /.match(author.text) 
		           author_elts = author.text.split(/ /)
		           last_name = author_elts[-1]
		           first_name = author_elts[0..-2].join(" ")
	            else 
  		           last_name = author.text
	             end
               end
            @author    = Person.find_or_create_by_first_name_and_last_name(first_name, last_name)
            #use author information to distinguish when two titles match in acm metadata
            l_authors ="#{l_authors}__#{first_name}_#{last_name}"
	   	   @paper.authors << @author
        end
       end#for unique anthology_id
    end
  end
end
end # namespace :anthology
