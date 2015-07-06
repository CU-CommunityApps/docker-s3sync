#!/usr/bin/ruby 

unless ENV['S3_BUCKET'] 
  puts "The environment variable S3_BUCKET has to be set"
  exit 1
end

DIRECTION = ENV['DIRECTION'] || 'BI'
SLEEP_SECONDS = ENV['SLEEP_SECONDS'] || 30
EXCLUDE_DIRS = ENV['EXCLUDE_DIRS'] || ""
EXCLUDE_FILES = ENV['EXCLUDE_FILES'] || ""

exclude_dir_list = ""
exclude_file_list = ""

def get_ts
  Time.now.utc.to_s
end

EXCLUDE_DIRS.split(",").each do |exclude|
  exclude_list += " --exclude \"*#{exclude}/*\""
end

EXCLUDE_FILES.split(",").each do |exclude|
  exclude_list += " --exclude \"#{exclude}\""
end

loop do
  start = Time.now
  
  puts "#{get_ts} starting sync"
  
  if DIRECTION.eql?("BI") or DIRECTION.eql?("UP")
    puts `aws s3 sync #{exclude_list} /sync s3://#{ENV['S3_BUCKET']}`
    puts "#{get_ts} finished upload, took #{Time.now - start}"
  end
  
  if DIRECTION.eql?("BI") or DIRECTION.eql?("DN")
    puts `aws s3 sync #{exclude_list} s3://#{ENV['S3_BUCKET']} /sync`
  end
  
  puts "#{get_ts} finished sync, took #{Time.now - start}"
  
  sleep SLEEP_SECONDS
end