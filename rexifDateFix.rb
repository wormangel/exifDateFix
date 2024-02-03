require 'colorize'
require 'mini_exiftool'
require 'highline/import'

directories = Array.new
Dir.glob('*').select { |d| File.directory?(d) && d != "#" }.each do |dir|
  directories << File.expand_path(dir)
end

puts "Number of directories to proccess: #{directories.size}".light_yellow

directories.each_with_index do |directory, i|
  puts "Scanning directory #{i+1}: #{directory}".light_yellow

  # Collect files
  files = Array.new
  Dir.foreach(directory) do |item|
    next if item == '.' or item == '..'
    next unless item.end_with? ".jpg" or item.end_with? ".JPG" or item.end_with? ".jpeg" or item.end_with? ".JPEG"
    
    # mount path: path to directory + filename
    path = directory + "/" + item
    
    photo = MiniExiftool.new path
    if photo.DateTimeOriginal == nil # if the file doesn't have the EXIF field
      files << path
    end
  end
  
  if files.empty?
    puts "No files to proccess.".light_green
  else
    puts "Number of files to proccess: #{files.size}".light_yellow
    files.each_with_index do |file, i|
      puts "  ##{i+1}: ".light_yellow + file
    end
    puts
  
    #prompt = HighLine.new
    #answer = prompt.agree("Continue? (yes/no)".light_blue)
    
    #if (answer)
    files.each do |file|
      puts "Processing #{file}".light_yellow
      `exiftool -v "-FileModifyDate>DateTimeOriginal" -P -overwrite_original_in_place "#{file}"`
    end
    #end
  end
  puts "Finished everything for this directory.".light_green
end

puts "Finished everything.".light_green

