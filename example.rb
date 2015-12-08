#!/usr/bin/ruby

require_relative 'tarsnap'

# optional settings:
# where_tarsnap:        "/usr/local/bin/tarsnap"
# log_path:             "/home/abc/.tarsnap/logs"
# prune_backups:        5 # delete backup after x days 

settings = [ { to_backup: "/home/abc/folder", backup_name: "folder"},
             { to_backup: "/home/abc/folder2", backup_name: "folder"} ]

settings.each do |setting|
  tarsnap = Tarsnap.new(setting)
  tarsnap.backup
end
