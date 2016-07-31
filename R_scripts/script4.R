#script4 - comparing changes in optimal route coverage
results_default_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)
results_custom_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)

# --- with time ---
results_default_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_19000_wo_parking_13_0815_0830_with_time.txt", header = FALSE)
results_custom_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_19000_wo_parking_13_0815_0830_with_time.txt", header = FALSE)

# --- Results_with_speed3 ---
timespan = "0845_0900"
results_default_speed_default_route <- read.table(paste0("/home/lukasz/Pulpit/Results_with_speed3/results_default_speed_default_route_19000_wo_parking_13_", timespan, "_with_time.txt"), header = FALSE)
results_custom_speed_default_route <- read.table(paste0("/home/lukasz/Pulpit/Results_with_speed3/results_custom_speed_default_route_19000_wo_parking_13_", timespan, "_with_time.txt"), header = FALSE)
results_custom_speed_custom_route <- read.table(paste0("/home/lukasz/Pulpit/Results_with_speed3/results_custom_speed_custom_route_19000_wo_parking_13_", timestamp, "_with_time.txt"), header = FALSE)

coverageDeltaFrame <- data.frame(id=integer(), delta=double(), timeDelta=double())
for (i in 1:length(results_default_speed_default_route$V1)) {
  coverageDelta = results_custom_speed_custom_route[i,2] - results_default_speed_default_route[i,2]
  optimalRouteTimeDiff = results_custom_speed_default_route[i,4] - results_custom_speed_custom_route[i,4];
  coverageDeltaFrame = rbind(coverageDeltaFrame, data.frame(id = results_custom_speed_custom_route[i,1], delta = coverageDelta, timeDelta = optimalRouteTimeDiff))
}
#coverageProgress = subset(coverageDeltaFrame, delta > 0)
#coverageProgress
#coverageRegress = subset(coverageDeltaFrame, delta < 0)
#coverageRegress

#timeChangeGroup = subset(coverageDeltaFrame, timeDelta != 0)
#summary(timeChangeGroup)
timeChangeGroupOthers = subset(coverageDeltaFrame, timeDelta != 0 & delta <= 0)
summary(timeChangeGroupOthers)
timeChangeGroupInfluenced = subset(coverageDeltaFrame, timeDelta != 0 & delta > 0)
summary(timeChangeGroupInfluenced)


#for (i in 1:length(coverageRegress[1])) {
#  url = paste("http://localhost/map.html?id=", coverageRegress[i,1])
#  browseURL(url, browser = getOption("browser"), encodeIfNeeded = FALSE)
#}


