#!/usr/bin/ruby


sourcepath = ARGV.first
puts "Reading #{sourcepath}"


data = Hash.new

file = IO.readlines(sourcepath)

file_length = file.length

line_index = 0

while(line_index < file_length) do
  head_content = file[line_index] # get content of current line
  highlight_info = file[line_index + 1].split("|")
  highlight_info_page = highlight_info[0][25..-2]
  puts "Highlight Page:#{highlight_info_page}"
  higlight_info_location = highlight_info[1][10..-2]
  puts "Highlight Location:#{higlight_info_location}"
  higlight_info_datetime = highlight_info[2].split(",").last[1..-3]
  puts "Highlight Datetime:#{higlight_info_datetime}"
  highlight_content = file[line_index + 3]
  higlight_info = "\'\'[P:#{highlight_info_page},Loc:#{higlight_info_location},#{higlight_info_datetime}]\'\'"

  book_id = head_content[0..10] # id for hash

  if data.key?(book_id) # it is not the first entry
    data[book_id][:content] = data[book_id][:content].push("#{highlight_content[0..-4]} #{higlight_info}")


  else # it is the first entry
    data[head_content[0..10]] = {title: head_content[0..(head_content.index('(')-1)],
                         author: head_content[/\((.*?)\)/],
                         content: ["#{highlight_content[0..-4]} #{higlight_info}"]}
  end
  line_index += 5
end


outputpath = "#{sourcepath[0..-18]}/clippings_wiki"
puts "Creating #{outputpath}"
File.open(outputpath, 'w') do |f|
  data.each do |book|
    f.print "Site-Name: #{book.last[:author]}. YEAR. #{book.last[:title]}\n"
    f.print "[[Category:Books]]\n"
    f.print "------------------------------------------------------------------\n"
    book.last[:content].each do |c|
      f.print "* #{c}\n"
    end
    f.print "------------------------------------------------------------------\n"
  end
end
STDOUT.flush
