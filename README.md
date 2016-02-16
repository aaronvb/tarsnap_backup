tarsnap_backup
==============

Manage your tarsnap backups with this scripts.
- configure your backups and start them automatically
- delete backups older than x days

Have a look at the example.rb to see how to configure your backup folders (and other settings).

To start the backup manually execute:
```bash
ruby example.rb
```

You can use cron to trigger the script automatically:
```bash
crontab -e
```

And add the following line to start a backup every day at 9 am:
```
0 09 * * * ruby path_to_script/example.rb
```
