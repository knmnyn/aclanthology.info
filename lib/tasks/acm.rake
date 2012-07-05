require 'yaml'

namespace :acm do
  desc "Load doi data from ACL xml files"
  task :load_doi => :environment do
    file = File.new ENV["xml_file"]
    puts "Processing File-- #{file.path}"
    doc = REXML::Document.new file
    doc.elements.each("doi_batch/body/conference/conference_paper") do |paper|
      l_title=paper.elements['titles/title'].text
      if not l_title
        l_title=paper.elements['titles/title/i'].text
      end
      l_subtitle=paper.elements['titles/subtitle'].text if paper.elements['titles/subtitle']
      
      if l_title #take care of <i></i>
        l_title = l_title+": "+l_subtitle if l_subtitle
        l_title = l_title.downcase.strip
        l_title= l_title.gsub /[:-]/,' ' 
        l_title= l_title.gsub '  ',' ' 
        l_doi=paper.elements['doi_data/doi'].text
      
        @l_papers= Paper.find_by_acmsearch l_title
        if @l_papers.is_a? Array    
          #puts "*****Multiple PAPERS*****"
        end
        
        if @l_papers
          #puts @l_papers.acmsearch
          @l_papers.doi = l_doi
          @l_papers.save
       else
        #puts "Not Found--#{l_title}"
       end
    end       
  end

  end
  task :show_doi => :environment do
   @all = Volume.find :all
    #paper = Paper.find_by_title "Using Chi-Square Testing in Modeling Confusion Characteristics for Robust Phonetic Set Generation"
    @all.each do |paper|
      puts "#{paper.anthology_id}"
    end
    #puts @all.size
  end
  
  desc "Extract Workshops related to SIG and add info to corresponding Volumes"
  task :add_siginfo => :environment do
    file = File.new(ENV["yaml_file"])
    yml = YAML::load(file)
    @sig = Siggroup.new
    @sig.name =yml["Name"]
    @sig.sigid=yml["ShortName"]
    @sig.url=yml["URL"]
    @sig.save
    yml["Meetings"].each do |meeting|
      keys=meeting.keys
      keys.each do |key|
        meeting[key].each do |venue|
          if venue.is_a? String
            @vol = Volume.find_by_anthology_id venue
            #anthology_id of volumes with bib_type is stored differently, with last 00 stripped
            venue_bib = venue.slice 0..-3
            @vol_bib =Volume.find_by_anthology_id venue_bib
            ######
            if @vol
                 @vol.sigid=@sig.sigid
                 @vol.save
            elsif @vol_bib
                  @vol_bib.sigid=@sig.sigid
                  @vol_bib.save
            end
          end

         end
      end
    end

  end# task add_siginfo

end #namespace

