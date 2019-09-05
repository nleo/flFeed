require_relative 'app'

puts Time.now

i = 0
projects = RFSP::Fl.parse_rss
print "fl"
projects.each do |p|
  next if Project.where(remote_id: p.id, site: 1).first
  Project.create_from_parsed_data p, 1
  i += 1
end
puts " loaded: #{i}"

i = 0
projects = RFSP::Weblancer.parse_rss
print "weblancer"
projects.each do |p|
  next if Project.where(remote_id: p.id, site: 2).first
  Project.create_from_parsed_data p, 2
  i += 1
end
puts " loaded: #{i}"

exit if Time.now.min > 4 && ARGV.first.nil?

i = 0
projects = RFSP::Freelansim.parse_rss
print "freelansim"
projects.each do |p|
  next if Project.where(remote_id: p.id, site: 3).first
  begin
    RFSP::Freelansim.parse_page p
  rescue => e
    puts "#{p.uri} #{e.class} #{e.message}"
    next
  end
  Project.create_from_parsed_data p, 3
  i += 1
end
puts " loaded: #{i}"
