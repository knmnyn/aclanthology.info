require 'yaml'


filename = ARGV[0]

yml = YAML::load(File.open(filename))
#puts yml["Meetings"][0][2010]
puts yml["ShortName"]

yml["Meetings"].each do |meeting|
	keys=meeting.keys
	keys.each do |key|
		#puts "Key: #{key} "
		meeting[key].each do |venue|
			if not venue.is_a? String
			 puts venue
			end
		end
	end

end
