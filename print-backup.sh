#!/bin/bash

# Set variables
dow=$(date +'%a')
month=$(date +'%m')
day=$(date +'%d')
year=$(date +'%Y')
isodate=$(date +'%Y-%m-%d')
backupdir=/mnt/backups
pcbackup=/home/papercut/server/data/backups/$(ls /home/papercut/server/data/backups/ -Art | tail -n 1)

# Daily backup operation
# Remove previous Daily backups
rm $backupdir/daily/cups/*.tar.gz
rm $backupdir/daily/ppd/*.tar.gz
rm $backupdir/daily/papercut/*.zip
# Create new Daily backups
nice -n 19 tar zcvf $backupdir/daily/cups/cups_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /etc/cups
nice -n 19 tar zcvf $backupdir/daily/cups/ppd_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /usr/share/ppd
nice -n 19 cp $pcbackup $backupdir/daily/papercut/
# Latest backups to Google Drive
nice -n 19 rclone delete GDrive:/Latest
nice -n 19 rclone copy $backupdir/daily/ GDrive:/Latest

# Weekly backup operation
if [[ ( $dow == "Sun" ) ]]; then

rm $backupdir/weekly/*.tar.gz
nice -n 19 tar zcvf $backupdir/weekly/print_backup_$(date +'%Y-%m-%d_%H%M').tar.gz $backupdir/daily
nice -n 19 rclone copy $backupdir/weekly/ GDrive:/Weekly

fi

# Monthly backup operation
if [[ ( $day == "01" ) ]]; then

nice -n 19 rclone copy $backupdir/weekly/ GDrive:/Monthly
nice -n 19 rclone delete GDrive:/Weekly

fi

# Yearly backup operation
if [[ ( $month-$day == "01-01" ) ]]; then

nice -n rclone delete GDrive:/Monthly

fi
