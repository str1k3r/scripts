#!/bin/bash
find /var/www/builds/ -maxdepth 1 -type f | xargs -x ls -t | awk 'NR>30' | xargs -L1 rm -fr