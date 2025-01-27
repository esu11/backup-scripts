#!/bin/bash

# Set variables
dow=$(date +'%a')
month=$(date +'%m')
day=$(date +'%d')
year=$(date +'%Y')
isodate=$year-$month-$day
latestbackup=/usr/lib/unifi/data/backup/autobackup/$(ls --ignore=*.json /usr/lib/unifi/data/backup/autobackup/ -Art | tail -n 1)

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
