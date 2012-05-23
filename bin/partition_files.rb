file = "Bibtype_counts"
f = File.open file, 'r'
lines= f.read.split
lines.each do |line|
	filename=line.split ":"
	bibcount=filename[1].to_i
	if bibcount > 0
	 system("cp antho-xml/#{filename[0]} ./with_bib_type")
	 #puts filename[0]+" "+filename[1]
	end
	#print filename[0]+" "+filename[1] +"--" 
end
