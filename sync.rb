#!/usr/bin/ruby 

unless ENV['S3_BUCKET'] 
  puts "The environment variable S3_BUCKET has to be set"
  exit 1
end

DIRECTION = ENV['DIRECTION'] || 'BI'
SLEEP_SECONDS = ENV['SLEEP_SECONDS'] || 1800

def get_ts
  Time.now.utc.to_s
end

loop do
  start = Time.now
  
  if DIRECTION.eql?("BI") or DIRECTION.eql?("UP")
    puts "#{get_ts} starting sync"
    puts `aws s3 sync /sync s3://#{ENV['S3_BUCKET']}`
    puts "#{get_ts} finished upload, took #{Time.now - start}"
  elsif DIRECTION.eql?("BI") or DIRECTION.eql?("DN")
    puts `aws s3 sync s3://#{ENV['S3_BUCKET']} /sync`
    puts "#{get_ts} finished sync, took #{Time.now - start}"
  end
  
  sleep SLEEP_SECONDS
end