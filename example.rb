#!/usr/bin/ruby

require_relative 'tarsnap'

# optional settings:
# where_tarsnap:        "/usr/local/bin/tarsnap"
# log_path:             "/home/abc/.tarsnap/logs"
# log_filename:         "tarsnap_backup.log"
# tarsnap options:      "--exclude pattern"
# number_to_keep:       "5"

settings = [ { to_backup: "/home/abc/folder", backup_name: "folder"},
             { to_backup: "/home/abc/folder2", backup_name: "folder", options: "--exclude pattern"},
             { to_backup: "/home/abc/folder2", backup_name: "folder"} ]

settings.each do |setting|
  tarsnap = Tarsnap.new(setting)
  tarsnap.backup
end
