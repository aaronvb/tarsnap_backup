tarsnap_backup
==============

Automated Tarsnap Backups in Ruby

I created this script to manage my tarsnap backups. I included the launchd script to manage the execution of the backup on a 4 hour interval.

The launchd script goes in /Library/LaunchDaemons.

```terminal
$ launchctl load /Library/LaunchDaemons/com.aaronvb.tarsnap-backup.plist
$ launchctl start com.aaronvb.tarsnap-backup
```

Here's an example if you want setup more than one backup:

```ruby
#!/usr/bin/ruby

require_relative 'tarsnap'

# backups for project folder
#
settings = {
  where_tarsnap: "/usr/local/bin/tarsnap",
  log_path: "/Users/aaronvb/.tarsnap/logs",
  to_backup: "/Users/aaronvb/projects",
  backup_name: "projects",
  prune_backups: 259200 # 3 days in seconds
}

tarsnap = Tarsnap.new(settings)
tarsnap.backup

# backups for document folder
#

settings = {
  where_tarsnap: "/usr/local/bin/tarsnap",
  log_path: "/Users/aaronvb/.tarsnap/logs",
  to_backup: "/Users/aaronvb/Documents",
  backup_name: "documents",
  prune_backups: 259200 # 3 days in seconds
}

tarsnap = Tarsnap.new(settings)
tarsnap.backup
```
