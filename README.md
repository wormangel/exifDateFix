# exifDateFix
Handy script to fix JPEG photos that lack the DateTimeOriginal EXIF field.
It examines all the JPEG files inside a given folder and see which ones lack that field. Then, for each of those files, it sets its DateTimeOriginal to the value of the file's ModifyDate filesystem attribute.

## Requirements
You need to install [ExifTool](http://www.sno.phy.queensu.ca/~phil/exiftool/) first. Make sure it's properly configured, the executable is in PATH, etc.

## Installing

```
bundle install
```

This project uses the awesome [colorize](https://github.com/janfri/mini_exiftool), [mini_exiftool](https://github.com/janfri/mini_exiftool) and [highline](https://github.com/JEG2/highline) gems.

## Usage

The script takes a single argument, the path to the directory you want to work on. Make sure there are some JPEG inside it and run:

`ruby exifDateFix.rb path/to/some/directory`

## Notes

- `mini_exiftool` is used here to read the file's EXIF data, but not to write - writing is done by directly executing `exiftools` from inside the ruby script (using backticks). 
I did some tests with said gem and apparently it messed a little with the filesystem date attributes for the file I tried to change, even though I've only changed the DateTimeOriginal EXIF field. 

-  exiftools is run using options `-P` (preserve filesystem timestamps) and `-overwrite_original_in_place` (to prevent the creation of a `.original` file and preserve file's creation date on supported systems.
Se more about those in [ExifTool docs](http://www.sno.phy.queensu.ca/~phil/exiftool/exiftool_pod.html))
