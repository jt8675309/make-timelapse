#!/usr/bin/env ruby
require 'date';
# generate timelapse of day before's snapshots

YESTERDAY = Date.today - 1;
SIZE      = '3280x2464'; #'1440x1080'; # '3280x2464';
FRAMERATE = 30

path = ARGV.first || ENV['TIMELAPSE_PATH'] || "/volume2/Data/pi3";

# input 
INPUT_PATH = File.join(path, YESTERDAY.year.to_s, "%02d" % YESTERDAY.month, "%02d" % YESTERDAY.day)

# output file
fn = [YESTERDAY.year.to_s, "%02d" % YESTERDAY.month, "%02d" % YESTERDAY.day].join("-")
OUTFILE = File.join(path, "#{fn}.mp4");

def timelapse(path, output)
  infiles = "-pattern_type glob -i '#{File.join(path, "*.jpg")}'"
  cmd = "~/bin/ffmpeg -y -framerate #{FRAMERATE} #{infiles} -s:v #{SIZE} -c:v libx264 -crf 17 -pix_fmt yuv420p '#{output}'"
  system(cmd)
end

if Dir.exists?(INPUT_PATH)
  puts "input path: #{INPUT_PATH} out: #{OUTFILE}"
  timelapse(INPUT_PATH, OUTFILE)  
else 
  raise StandardError, "Input path #{INPUT_PATH} doesn't exist. No timelapse to generate"
end

