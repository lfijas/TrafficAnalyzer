#!/bin/bash
START_DATE="2015-02-12 00:00:00"
END_DATE="2015-02-12 00:15:00"
DATE_LIMIT=$(date -d "2015-02-13 00:00:00" +"%s")
END_DATE_TIMESTAMP=$(date -d "$END_DATE" +"%s")
while [ $END_DATE_TIMESTAMP -le $DATE_LIMIT ];
do
	FILE_DATE_SUFFIX=$(date '+%d_%H%M' -d "$START_DATE")_$(date '+%H%M' -d "$END_DATE")
	
	java -jar /home/lukasz/Pulpit/Magisterskie/Praca_magisterska/GraphHopper/Dev/GraphHopper_routing/out/artifacts/GraphHopper_routing_jar/GraphHopper_routing.jar "$START_DATE" "$END_DATE" false /home/lukasz/Pulpit/Results_WAW_Bridges4/results_custom_speed_default_route_wo_parking_waw_$FILE_DATE_SUFFIX.txt
	
	java -jar /home/lukasz/Pulpit/Magisterskie/Praca_magisterska/GraphHopper/Dev/GraphHopper_routing/out/artifacts/GraphHopper_routing_jar/GraphHopper_routing.jar "$START_DATE" "$END_DATE" true /home/lukasz/Pulpit/Results_WAW_Bridges4/results_custom_speed_custom_route_wo_parking_waw_$FILE_DATE_SUFFIX.txt
	
	START_DATE=$(date '+%Y-%m-%d %T' --date="$START_DATE 15 minutes")
	END_DATE=$(date '+%Y-%m-%d %T' --date="$END_DATE 15 minutes")
	END_DATE_TIMESTAMP=$(date -d "$END_DATE" +"%s")
done
