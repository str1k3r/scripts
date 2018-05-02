#!/bin/bash
#settings
 
#patititon
FILESYSTEM=/dev/mmcblk0p3
#delete if FS is over 90% of usage
CAPACITY=90
#cleanup path
CSV_DIR=/var/spool/itrackbox/accel/
#files age gzip (minutes) and delete (days)
AGE_GZIP=60
AGE_DELETE=1
 
if [ $(df -P $FILESYSTEM | awk '{ gsub("%",""); capacity = $5 }; END { print capacity }') -gt $CAPACITY ]
then
    find "$CSV_DIR" -maxdepth 1 -type f -mmin +$AGE_GZIP   -exec gzip {} \;
    find "$CSV_DIR" -maxdepth 1 -type f -mtime +$AGE_DELETE -exec rm -f {} \;
fi