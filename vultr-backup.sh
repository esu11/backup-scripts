#!/bin/bash

# Set variables
dow=$(date +'%a')
month=$(date +'%m')
day=$(date +'%d')
year=$(date +'%Y')
isodate=$(date +'%Y-%m-%d')
backupdir=/mnt/backups

# Daily backup operation
# Remove previous Daily backups
rm $backupdir/daily/letsencrypt/*.tar.gz
rm $backupdir/daily/apache2/*.tar.gz
rm $backupdir/daily/mysql/*.tar.gz
rm $backupdir/daily/php/*.tar.gz
rm $backupdir/daily/www/*.tar.gz
rm $backupdir/daily/logs/*.tar.gz
rm $backupdir/daily/cron/*.tar.gz
rm $backupdir/daily/home/*.tar.gz
# Create new Daily backups
nice -n 19 tar zcvf $backupdir/daily/letsencrypt/letsencrypt_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /etc/letsencrypt
nice -n 19 tar zcvf $backupdir/daily/apache2/apache2_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /etc/apache2
nice -n 19 tar zcvf $backupdir/daily/mysql/mysql_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /var/lib/automysqlbackup/latest
nice -n 19 tar zcvf $backupdir/daily/php/php_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /etc/php
nice -n 19 tar zcvf $backupdir/daily/www/www_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /var/www
nice -n 19 tar zcvf $backupdir/daily/logs/logs_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /var/log/apache2
nice -n 19 tar zcvf $backupdir/daily/cron/cron_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /var/spool/cron/crontabs
nice -n 19 tar zcvf $backupdir/daily/home/home_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /home
# Latest backups to Google Drive
nice -n 19 rclone delete GDrive:/Latest
nice -n 19 rclone copy $backupdir/daily/ GDrive:/Latest

# Weekly backup operation
if [[ ( $dow == "Sun" ) ]]; then

rm $backupdir/weekly/*.tar.gz
nice -n 19 tar zcvf $backupdir/weekly/esu11_vultr_backup_$(date +'%Y-%m-%d_%H%M').tar.gz $backupdir/daily
nice -n 19 rclone copy $backupdir/weekly/ GDrive:/Weekly

fi

# Monthly backup operation
if [[ ( $day == "01" ) ]]; then

nice -n 19 rclone copy $backupdir/weekly/ GDrive:/Monthly
nice -n 19 rclone delete GDrive:/Weekly

fi

# Yearly backup operation
if [[ ( $month-$day == "01-01" ) ]]; then

nice -n 19 rclone delete GDrive:/Monthly

fi
