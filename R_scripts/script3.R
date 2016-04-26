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
for (i in 1:length(groupedResults)) {
  groupedResultsFrame <- rbind(groupedResultsFrame, c(mean(as.data.frame(groupedResults[i])[, 1]), i))
}  
plot(groupedResultsFrame$X1, groupedResultsFrame$X0, xlab="Długość trasy", ylab="Średnie pokrycie z trasą optymalną",
     col="red", lwd=3)
lines(groupedResultsFrame$X1, groupedResultsFrame$X0, col="blue", lwd=3)

#cut2(results$V2, g=10)
#cut(results$V2, 10)
