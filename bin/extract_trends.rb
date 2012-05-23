#!/usr/bin/ruby
#
# parameter_stats.log contains only "Parameters:{ } lines from heroku logs"
#
file = File.new "../log/parameters_stats.log","r"

paper_count={}
author_count={}
while (line=file.gets)
    param=line.split "=>"
    raw_str= param[0]
    if raw_str.end_with? '"id"'
        raw_id=param[1]
        paper_id=raw_id[1..raw_id.length-4]
        if paper_count.has_key? paper_id
          paper_count[paper_id] +=1
        else
          paper_count[paper_id]=1
        end
    end
    if raw_str.end_with? '"author"'
        raw_id=param[1]
        author_id=raw_id[1..raw_id.length-4]
        author_id=author_id.strip
        if author_count.has_key? author_id
          author_count[author_id] += 1
        else
          author_count[author_id] =1
        end
    end
end
paper_count= paper_count.sort { |l,r| l[1] <=> r[1]}
author_count= author_count.sort { |l,r| l[1] <=> r[1]}

file_p = File.open '../app/trends/trending_papers','w'
file_a = File.open '../app/trends/trending_authors','w'
for i in 0..6 do
    file_a.puts "#{author_count.reverse[i][0]}"
end
for i in 0..7 do
    file_p.puts "#{paper_count.reverse[i][0] if paper_count.reverse[i][0] != "jquery"}"
end
file_p.close
file_a.close
