#!/bin/bash

FROM=2017-08          # To Be Configured : Starting date        Accepted format : (YY-MM) or (YY-MM-DD)
TO=2019-12	      # To be configured : Last partition date  Accepted format : (YY-MM) or (YY-MM-DD)

d=$FROM
day=$(echo $d | cut -d\- -f3)
if [ -z $day ] ; then
	d=$(echo "${FROM}-01")
fi
dayto=$(echo $TO | cut -d\- -f3)
if [ -z $dayto ] ; then
        TO=$(echo "${TO}-01")
fi

echo "d=$d==, TO=$TO="
now="$(date +'%d-%m-%Y')"

while [ "$d" != "$TO" ]; do 
	echo $d
	d=$(date -I -d "$d + 1 month")
	y=$(echo $d | cut -d\- -f1)
	m=$(echo $d | cut -d\- -f2 )
	PARTITION=$(echo "P${y}${m}")
	TIMESTAMP=$(date -d "$d + 1month" +%s)
	echo "PARTITON ($PARTITION), Timestamp=($TIMESTAMP)"
	echo "ALTER TABLE log_history ADD PARTITION (PARTITION  $PARTITION VALUES LESS THAN ($TIMESTAMP));" >> /tmp/log_history_${now}.sql

done



