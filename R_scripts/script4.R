#script4 - comparing changes in optimal route coverage
results_default_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)
results_custom_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)

# --- with time ---
results_default_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_19000_wo_parking_13_0815_0830_with_time.txt", header = FALSE)
results_custom_speed <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_19000_wo_parking_13_0815_0830_with_time.txt", header = FALSE)

# --- Results_with_speed4 ---
timespan = "waw_19_0800_0815"
#results_default_speed_default_route <- read.table(paste0("/home/lukasz/Pulpit/Results_with_speed3/results_default_speed_default_route_19000_wo_parking_", timespan, "_with_time.txt"), header = FALSE)
results_custom_speed_default_route <- read.table(paste0("/home/lukasz/Pulpit/Results_WAW3/results_custom_speed_default_route_wo_parking_", timespan, ".txt"), header = FALSE)
results_custom_speed_custom_route <- read.table(paste0("/home/lukasz/Pulpit/Results_WAW3/results_custom_speed_custom_route_wo_parking_", timespan, ".txt"), header = FALSE)

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

allResults <- data.frame(id=integer(), delta=double(), timeDelta=double(), precentageTimeProfit=double(), routeLength=double())

allResultsInfluenced = subset(allResults, delta > 0)
allResultsOthers = subset(allResults, delta <= 0)


plot(allResults$delta * 100, allResults$timeDelta / 1000, type = "p",
     xlab="Zmiana pokrycia z trasą optymalną [p.p]",
     ylab="Zysk z poruszania się po trasie optymalnej z uwzględnieniem ruchu [s]", col="blue")
points(allResults$delta * 100, allResults$timeDelta / 1000, type = "p", col="red")
hist(allResults$delta * 100, xlab="Zmiana pokrycia z trasą optymalną [p.p]",breaks=seq(-100, 100, 1), main="")
plot(allResults$delta * 100, allResults$routeLength, type = "p",
     xlab="Zmiana pokrycia z trasą optymalną [p.p]",
     ylab="Długość przejazdu [km]")
plot(allResults$delta * 100, allResults$routeLength, type = "p",
     xlab="Zmiana pokrycia z trasą optymalną [p.p]",
     ylab="Długość przejazdu [km]", ylim=c(0, 100))
plot(allResults$delta, allResults$timeDelta, type = "p", col="red", ylim=c(0, 100000))

#for (i in 1:length(coverageRegress[1])) {
#  url = paste("http://localhost/map.html?id=", coverageRegress[i,1])
#  browseURL(url, browser = getOption("browser"), encodeIfNeeded = FALSE)
#}

#results grouped by length
allResultsSubsetLongRoute = subset(allResults, routeLength > 20)
allResultsSubsetShortRoute = subset(allResults, routeLength <= 20)
plot(allResultsSubsetLongRoute$delta * 100, allResultsSubsetLongRoute$timeDelta / 1000, type = "p",
     xlab="Zmiana pokrycia z trasą optymalną [p.p]",
     ylab="Zysk z poruszania się po trasie optymalnej z uwzględnieniem ruchu [s]", col="blue")
points(allResultsSubsetShortRoute$delta * 100, allResultsSubsetShortRoute$timeDelta / 1000, type = "p", col="red")

longRouteInfluenced = subset(allResultsSubsetLongRoute, delta > 0)
longRouteOthers = subset(allResultsSubsetLongRoute, delta <= 0)

shortRouteInfluenced = subset(allResultsSubsetShortRoute, delta > 0)
shortRouteOthers = subset(allResultsSubsetShortRoute, delta <= 0)

#results grouped by route time
routeTimeGroup1 = subset(allResults, timeDelta > 0 & timeDelta <= 25000)
summary(routeTimeGroup1)
routeTimeGroup2 = subset(allResults, timeDelta > 25000 & timeDelta <= 50000)
summary(routeTimeGroup2)
routeTimeGroup3 = subset(allResults, timeDelta > 50000 & timeDelta <= 100000)
summary(routeTimeGroup3)
routeTimeGroup4 = subset(allResults, timeDelta > 100000 & timeDelta <= 150000)
summary(routeTimeGroup4)
routeTimeGroup5 = subset(allResults, timeDelta > 150000)
summary(routeTimeGroup5)