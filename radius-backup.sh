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
rm $backupdir/daily/freeradius/*.tar.gz
rm $backupdir/daily/logs/*.tar.gz
# Create new Daily backups
nice -n 19 tar zcvf $backupdir/daily/letsencrypt/letsencrypt_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /etc/letsencrypt
nice -n 19 tar zcvf $backupdir/daily/freeradius/freeradius_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /etc/freeradius
nice -n 19 tar zcvf $backupdir/daily/logs/logs_backup_$(date +'%Y-%m-%d_%H%M').tar.gz /var/log/freeradius
# Latest backups to Google Drive
nice -n 19 rclone delete GDrive:/Latest
nice -n 19 rclone copy $backupdir/daily/ GDrive:/Latest

# Weekly backup operation
if [[ ( $dow == "Sun" ) ]]; then

rm $backupdir/weekly/*.tar.gz
nice -n 19 tar zcvf $backupdir/weekly/radius_backup_$(date +'%Y-%m-%d_%H%M').tar.gz $backupdir/daily
nice -n 19 rclone copy $backupdir/weekly/ GDrive:/Weekly
nice -n 19 sh /etc/letsencrypt/renewal-hooks/post/certbotrenew.sh
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
