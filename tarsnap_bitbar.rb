#!/usr/bin/ruby
require 'json'
require 'time'

log_folder = '/Users/aaronvb/.tarsnap/logs'

puts 'Tarsnap | size=11 font=menlo'
puts '---'

if Dir.exist?(log_folder)
  Dir.glob("#{log_folder}/bitbar_*.json") do |file|
    backups = JSON.parse(File.read(file))
    backups.each do |k, v|
      puts "Last Backup of #{k}"
      if v['last_run'] == "Backing Up Now..."
        puts "Backing Up Now..."
      else
        if Time.parse(v['last_run']).to_date == Date.today
          puts "Today, #{Time.parse(v['last_run']).strftime('%-I:%M %p')}"
        else
          puts Time.parse(v['last_run']).strftime('%b %-d, %-I:%M %p')
        end
      end
      puts '---'
    end
  end

  puts 'Backup Now | bash=/usr/bin/ruby param1=/Users/aaronvb/.tarsnap/tasks/backup.rb terminal=false'
  puts '---'
else
  puts 'Could not find log folder.'
end
