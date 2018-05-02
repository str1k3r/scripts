#!/bin/bash

instanceID=INSTANCE_NAME
date=$(date +%Y%m%d)

function downloadLog () {
  local log=$1

  aws rds download-db-log-file-portion \
    --output text \
    --db-instance-identifier $instanceID \
    --log-file-name $log
}

downloadLog slowquery/mysql-slowquery.log > /var/log/aws-rds/slow-$date.log

for i in $(seq 0 23); do
  downloadLog slowquery/mysql-slowquery.log.$i >> /var/log/aws-rds/slow-$date.log
done