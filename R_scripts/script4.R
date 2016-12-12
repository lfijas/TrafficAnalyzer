#script4 - comparing changes in optimal route coverage
results_default_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)
results_custom_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)

# --- with time ---
results_default_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_19000_wo_parking_13_0815_0830_with_time.txt", header = FALSE)
results_custom_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_19000_wo_parking_13_0815_0830_with_time.txt", header = FALSE)

# --- Results_with_speed4 ---
timespan = "15_1715_1730"
#results_default_speed_default_route <- read.table(paste0("/home/lukasz/Pulpit/Results_with_speed3/results_default_speed_default_route_19000_wo_parking_", timespan, "_with_time.txt"), header = FALSE)
results_custom_speed_default_route <- read.table(paste0("/home/lukasz/Pulpit/Results_with_speed5/results_custom_speed_default_route_wo_parking_", timespan, ".txt"), header = FALSE)
results_custom_speed_custom_route <- read.table(paste0("/home/lukasz/Pulpit/Results_with_speed5/results_custom_speed_custom_route_wo_parking_", timespan, ".txt"), header = FALSE)

coverageDeltaFrame <- data.frame(id=integer(), delta=double(), timeDelta=double(), precentageTimeProfit=double(), routeLenght=double())
for (i in 1:length(results_custom_speed_default_route$V1)) {
  coverageDelta = results_custom_speed_custom_route[i,2] - results_custom_speed_default_route[i,2]
  optimalRouteTimeDiff = results_custom_speed_default_route[i,5] - results_custom_speed_custom_route[i,5]
  percentageTimeDiff = optimalRouteTimeDiff / results_custom_speed_default_route[i,5] * 100
  distance = results_custom_speed_custom_route[i, 4]
  coverageDeltaFrame = rbind(coverageDeltaFrame, data.frame(id = results_custom_speed_custom_route[i,1], delta = coverageDelta, timeDelta = optimalRouteTimeDiff, percentageTimeProfit = percentageTimeDiff, routeLength=distance))
}
#coverageProgress = subset(coverageDeltaFrame, delta > 0)
#coverageProgress
#coverageRegress = subset(coverageDeltaFrame, delta < 0)
#coverageRegress

#timeChangeGroup = subset(coverageDeltaFrame, timeDelta != 0)
#summary(timeChangeGroup)
timeChangeGroupOthers = subset(coverageDeltaFrame, timeDelta != 0 & delta <= 0)
summary(timeChangeGroupOthers)
allResults <- rbind(allResults, timeChangeGroupOthers)
timeChangeGroupInfluenced = subset(coverageDeltaFrame, timeDelta != 0 & delta > 0)
summary(timeChangeGroupInfluenced)
allResults <- rbind(allResults, timeChangeGroupInfluenced)

#allResults <- data.frame(id=integer(), delta=double(), timeDelta=double(), precentageTimeProfit=double(), routeLength=double())
plot(allResults$delta * 100, allResults$timeDelta / 1000, type = "p",
     xlab="Zmiana pokrycia z trasą optymalną [p.p]",
     ylab="Zysk z poruszania się po trasie optymalnej z uwzględnieniem ruchu [s]")
hist(allResults$delta * 100, xlab="Zmiana pokrycia z trasą optymalną [p.p]",breaks=seq(-100, 100, 1), main="")
plot(allResults$delta * 100, allResults$routeLength, type = "p",
     xlab="Zmiana pokrycia z trasą optymalną [p.p]",
     ylab="Długość przejazdu [km]")
plot(allResults$delta, allResults$timeDelta, type = "p", col="red", ylim=c(0, 100000))

#for (i in 1:length(coverageRegress[1])) {
#  url = paste("http://localhost/map.html?id=", coverageRegress[i,1])
#  browseURL(url, browser = getOption("browser"), encodeIfNeeded = FALSE)
#}


