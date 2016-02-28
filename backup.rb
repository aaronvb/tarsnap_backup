#!/usr/bin/ruby

require_relative 'tarsnap'

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
