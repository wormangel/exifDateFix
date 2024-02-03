require 'colorize'
require 'mini_exiftool'
require 'highline/import'

dir = ARGV[0]

unless dir
  raise ArgumentError.new("Usage: exifDateFix <directory_path>".green)
end

unless File.exist?(dir)
  raise ArgumentError.new("Directory not found: #{dir}")
end

# get full path
dir = File.expand_path(dir)

puts "Scanning directory: #{dir}".light_yellow

files = Array.new

Dir.foreach(dir) do |item|
  next if item == '.' or item == '..'
  next unless item.end_with? ".jpg" or item.end_with? ".JPG" or item.end_with? ".jpeg" or item.end_with? ".JPEG"
  
  # mount path: path to dir + filename
  path = dir + "/" + item
  
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

  prompt = HighLine.new
  answer = prompt.agree("Continue? (yes/no)".light_blue)
  
  if (answer)
    files.each do |file|
      puts "Processing #{file}".light_yellow
      `exiftool -v "-FileModifyDate>DateTimeOriginal" -P -overwrite_original_in_place "#{file}"`
    end
  end
  
  puts "Finished everything.".light_green
end