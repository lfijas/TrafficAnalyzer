results <- read.table("/home/lukasz/Pulpit/Results/coverage_results.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results/coverage_results_without_parking.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results/coverage_results_without_parking_long.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results/dijkstra_coverage_results_without_parking_long.txt", header = FALSE)

#Results2
results <- read.table("/home/lukasz/Pulpit/Results2/results_fastest_traffic_1000.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results2/results_shortest_traffic_1000.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results2/results_fastest_traffic_wo_parking_1000.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results2/results_shortest_traffic_wo_parking_1000.txt", header = FALSE)

#Results with speed
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_custom_speed_wo_parking_1000.txt", header = FALSE)

results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_default_speed_wo_parking_morning.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_custom_speed_wo_parking_morning.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_default_speed_wo_parking_morning_14.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_custom_speed_wo_parking_morning_14.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_default_speed_3000_wo_parking_morning_13.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_custom_speed_3000_wo_parking_morning_13.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_default_speed_3000_wo_parking_morning_14.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed/results_custom_speed_3000_wo_parking_morning_14.txt", header = FALSE)

#Results_with_speed2
results <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_14000_wo_parking_14_0815_0830.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_14000_wo_parking_14_0815_0830.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_14000_wo_parking_13_1215_1230.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_14000_wo_parking_13_1215_1230.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_14000_wo_parking_13_0815_0830.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_14000_wo_parking_13_0815_0830.txt", header = FALSE)

# *** Results_with_speed2 with id ***
results <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_default_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)
results <- read.table("/home/lukasz/Pulpit/Results_with_speed2/results_custom_speed_19000_wo_parking_13_0815_0830.txt", header = FALSE)

results$V2[!is.finite(results$V2)] <- NA
processedResults <- results$V2[complete.cases(results$V2)]
summary(processedResults)
var(processedResults)

# *** ***

results$V1[!is.finite(results$V1)] <- NA
processedResults <- results$V1[complete.cases(results$V1)]
mean(processedResults)
summary(processedResults)
sd(processedResults)
var(processedResults)

#groupedResults <- split(results, cut(results$V2, 10))
groupedResults <- split(results, cut2(results$V2, g=10))
length(groupedResults)
groupedResultsFrame <- data.frame(coverage=double(), group=integer())
groupedResultsFrame2 <- data.frame(length=double(), group=integer())
for (i in 1:length(groupedResults)) {
  groupedResultsFrame <- rbind(groupedResultsFrame, c(mean(as.data.frame(groupedResults[i])[, 1]), i))
  groupedResultsFrame2 <- rbind(groupedResultsFrame2, c(mean(as.data.frame(groupedResults[i])[, 2]), i))
}  
plot(groupedResultsFrame$X1, groupedResultsFrame$X0, xlab="Długość trasy", ylab="Średnie pokrycie z trasą optymalną",
     col="red", lwd=3)
lines(groupedResultsFrame$X1, groupedResultsFrame$X0, col="blue", lwd=3)

plot(groupedResultsFrame2$X1, groupedResultsFrame2$X0, xlab="Długość trasy", ylab="Średnie pokrycie z trasą optymalną",
     col="green", lwd=3)
lines(groupedResultsFrame2$X1, groupedResultsFrame2$X0, col="green", lwd=3)
groupedResultsFrame2$X0 * 111

#cut2(results$V2, g=10)
#cut(results$V2, 10)
