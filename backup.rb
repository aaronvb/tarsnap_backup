#!/usr/bin/ruby

require_relative 'tarsnap'

# Return if running on battery
battery_status = `pmset -g batt`
battery_status = battery_status.split(/\r?\n/).first
return if battery_status == "Now drawing from 'Battery Power'"

settings = {
  where_tarsnap: "/usr/local/bin/tarsnap",
  log_path: "/Users/aaronvb/.tarsnap/logs",
  to_backup: "/Users/aaronvb/projects",
  backup_name: "projects",
  prune_backups: 259200, # 3 days in seconds
  bitbar: true
}

tarsnap = Tarsnap.new(settings)
tarsnap.backup
