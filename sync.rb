#!/usr/bin/ruby

unless ENV['S3_BUCKET']
  puts "The environment variable S3_BUCKET has to be set"
  exit 1
end

DIRECTION = ENV['DIRECTION'] || 'UP'
SLEEP_SECONDS = ENV['SLEEP_SECONDS'].to_i || 30
EXCLUDE_DIRS = ENV['EXCLUDE_DIRS'] || ""
EXCLUDE_FILES = ENV['EXCLUDE_FILES'] || ""
SKIP_INITIAL_DOWN = ENV['SKIP_INITIAL_DOWN'] || ""

$exclude_list = ""
EXCLUDE_DIRS.split(",").each do |exclude|
  $exclude_list += " --exclude \"*#{exclude}/*\""
end

EXCLUDE_FILES.split(",").each do |exclude|
  $exclude_list += " --exclude \"#{exclude}\""
end

def get_ts
  Time.now.utc.to_s
end

def up_sync
  puts `aws s3 sync #{$exclude_list} /sync s3://#{ENV['S3_BUCKET']}`
end

def dn_sync
  puts `aws s3 sync #{$exclude_list} s3://#{ENV['S3_BUCKET']} /sync`
end

def sync
  start = Time.now
  puts "#{get_ts} starting sync"
  yield
  puts "#{get_ts} finished sync, took #{Time.now - start}"
end

unless SKIP_INITIAL_DOWN
  # run an initial down sync.
  puts "#{get_ts} starting initial down sync"
  2.times do
    sync {dn_sync}
  end
  puts "#{get_ts} finished initial down sync"
end

loop do

  if DIRECTION.eql?("UP")
    sync {up_sync}
  end

  if DIRECTION.eql?("DN")
    sync {dn_sync}
  end

  sleep SLEEP_SECONDS
end
