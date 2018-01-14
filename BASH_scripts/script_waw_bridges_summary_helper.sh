#!/bin/bash
START_DATE="2015-02-12 00:00:00"
END_DATE="2015-02-12 00:15:00"
DATE_LIMIT=$(date -d "2015-02-13 00:00:00" +"%s")
END_DATE_TIMESTAMP=$(date -d "$END_DATE" +"%s")
while [ $END_DATE_TIMESTAMP -le $DATE_LIMIT ];
do
	TIMESPAN=waw_$(date '+%d_%H%M' -d "$START_DATE")_$(date '+%H%M' -d "$END_DATE")
	echo $TIMESPAN >> test.txt

	START_DATE=$(date '+%Y-%m-%d %T' --date="$START_DATE 15 minutes")
	END_DATE=$(date '+%Y-%m-%d %T' --date="$END_DATE 15 minutes")
	END_DATE_TIMESTAMP=$(date -d "$END_DATE" +"%s")
done
