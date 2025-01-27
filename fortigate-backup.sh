#!/bin/bash

# Set variables
dow=$(date +'%a')
month=$(date +'%m')
day=$(date +'%d')
year=$(date +'%Y')
isodate=$(date +'%Y-%m-%d')
backupdir=/home/fortigate/backups
gate=$(ls /home/fortigate/backups/ | grep \.conf$)

# Daily backup operation
# Remove previous Daily Backups
rm $backupdir/daily/*.conf
# Create new Daily backups
nice -n 19 mv $backupdir/*.conf $backupdir/daily/$(date +'%Y-%m-%d')_$gate
# Latest backups to Google Drive
nice -n 19 rclone delete GDrive:/Latest
nice -n 19 rclone copy $backupdir/daily/ GDrive:/Latest

# Weekly backup operation
if [[ ( $dow == "Sun" ) ]]; then

rm $backupdir/weekly/*.conf
nice -n 19 cp $backupdir/daily/*.conf $backupdir/weekly/
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
