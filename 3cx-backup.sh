#!/bin/bash

# Set variables
dow=$(date +'%a')
month=$(date +'%m')
day=$(date +'%d')
year=$(date +'%Y')
isodate=$(date +'%Y-%m-%d')

# Rename backup file, then assign lastbackup variable
mv /var/lib/3cxpbx/Instance1/Data/Backups/3CXScheduledBackup.zip /var/lib/3cxpbx/Instance1/Data/Backups/3CXScheduledBackup-$isodate.zip
latestbackup=/var/lib/3cxpbx/Instance1/Data/Backups/3CXScheduledBackup-$isodate.zip

# Daily backup operation
rclone delete GDrive:/Latest
rclone copy $latestbackup GDrive:/Latest
rclone copy /root/.config/rclone/rclone.conf GDrive:

# Weekly backup operation
if [[ ( $dow == "Sun" ) ]]; then

rclone copy $latestbackup GDrive:/Weekly

fi

# Monthly backup operation
if [[ ( $day == "01" ) ]]; then

rclone copy $latestbackup GDrive:/Monthly
rclone delete GDrive:/Weekly

fi

# Yearly backup operation
if [[ ( $month-$day == "01-01" ) ]]; then

rclone delete GDrive:/Monthly

fi
