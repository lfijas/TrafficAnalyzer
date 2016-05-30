#script4 - comparing changes in optimal route coverage
results_default_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)
results_custom_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)

coverageDeltaFrame <- data.frame(id=integer(), delta=double())
for (i in 1:length(results_default_speed$V1)) {
  coverageDelta = results_custom_speed[i,2] - results_default_speed[i,2]
  coverageDeltaFrame = rbind(coverageDeltaFrame,data.frame(id = results_custom_speed[i,1], delta = coverageDelta))
}
subset(coverageDeltaFrame, delta > 0)
coverageRegress = subset(coverageDeltaFrame, delta < 0)
#for (i in 1:length(coverageRegress[1])) {
#  url = paste("http://localhost/map.html?id=", coverageRegress[i,1])
#  browseURL(url, browser = getOption("browser"), encodeIfNeeded = FALSE)
#}


