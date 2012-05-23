#!/usr/bin/ruby
#
# A utility program to process heroku logs to extract necessary statistics information about facets, query features
file = File.new "parameters_stats.log","r"

query_lines=[]
author_pages =[]
catalog_pages = []
facet_requests = []

while (line=file.gets)
    param=line.split "=>"
    if line.include? '"q"=>'
      query_lines << line
    end
    if line.include? '"author"=>'
      author_pages << line
    end
    if line.include? '"id"=>'
      catalog_pages << line
    end
    if line.include? '"f"=>'
      facet_requests << line
    end
end

author_facets=[]
venue_facets=[]
sig_facets =[]
year_facets = []
attachment_facets =[]

numberof_facets = Hash.new { |h, k| h[k] = Array.new }
frequent_patterns = Hash.new { |h, k| h[k] = Array.new }


facet_requests.each do |facet_request|
  all_facets = []
  facet_pattern = ""
  if facet_request.include? "attachments"
    attachment_facets << facet_request
    facet_pattern = facet_pattern+"attachments_"
    all_facets << "attachments"
  end
  if facet_request.include? "author_facet"
    author_facets << facet_request
    facet_pattern = facet_pattern+"authorfacet_"
    all_facets << "author_facet"
  end
  if facet_request.include? "siginfo"
    sig_facets << facet_request
    facet_pattern = facet_pattern+"siginfo_"
    all_facets << "siginfo"
  end
  if facet_request.include? "venue"
    venue_facets << facet_request
    facet_pattern = facet_pattern+"venu_"
    all_facets << "venue"
  end
  if facet_request.include? "year"
    year_facets << facet_request
    facet_pattern = facet_pattern+"year_"
    all_facets << "year"
  end
  numberof_facets[all_facets.size].push (all_facets)
  frequent_patterns[facet_pattern].push (facet_request)
end

puts "Catalog Pages: #{catalog_pages.size}-666"
puts "Author Pages: #{author_pages.size}"
puts "Query Lines: #{query_lines.size}"
puts "Facet Requests: #{facet_requests.size}"
puts "Author facets: #{author_facets.size}"
puts "Venue facets: #{venue_facets.size}"
puts "Year facets: #{year_facets.size}"
puts "SIG facets: #{sig_facets.size}"
puts "Attachment facets: #{attachment_facets.size}"
puts "All facets count: #{numberof_facets.size}"

frequent_patterns.keys.each do |facet_size|

  puts "#{facet_size} #{frequent_patterns[facet_size].size}"
end
