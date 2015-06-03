#!/usr/bin/ruby 

unless ENV['S3_BUCKET'] 
  puts "The environment variable S3_BUCKET has to be set"
  exit 1
end

def get_ts
  Time.now.utc.to_s
end

loop do
  start = Time.now
  puts "#{get_ts} starting sync"
  puts `aws s3 sync /sync s3://#{ENV['S3_BUCKET']}`
  puts "#{get_ts} finished upload, took #{Time.now - start}"
  puts `aws s3 sync s3://#{ENV['S3_BUCKET']} /sync`
  puts "#{get_ts} finished sync, took #{Time.now - start}"
  sleep 30
end