#script5 - Warsaw bridges
library(gtools)

#grouping routes by time profit (based on script 4)

timespans <- read.table("/home/lukasz/Pulpit/Results_WAW_Bridges4/timespans2.txt", header = FALSE)

timeDeltaFrame <- data.frame(id=integer(), timeDelta=double(), precentageTimeProfit=double(), routeLenght=double())

for (i in 1:length(timespans$V1)) {
  timespan = timespans[i,1]
  results_custom_speed_default_route <- read.table(paste0("/home/lukasz/Pulpit/Results_WAW_Bridges5/results_custom_speed_default_route_wo_parking_", timespan, "_bridges_blind.txt"), header = FALSE)
  results_custom_speed_custom_route <- read.table(paste0("/home/lukasz/Pulpit/Results_WAW_Bridges5/results_custom_speed_custom_route_wo_parking_", timespan, "_bridges_traffic.txt"), header = FALSE)
  
  results_custom_speed_default_route = unique(results_custom_speed_default_route)
  results_custom_speed_custom_route = unique(results_custom_speed_custom_route)
  
  for (i in 1:length(results_custom_speed_default_route$V1)) {
    results_custom_speed_custom_route_matched_row = results_custom_speed_custom_route[results_custom_speed_custom_route$V1 == results_custom_speed_default_route[i,1],]
    if (!invalid(results_custom_speed_custom_route_matched_row)) {
      optimalRouteTimeDiff = results_custom_speed_default_route[i,3] - results_custom_speed_custom_route_matched_row$V3
      percentageTimeDiff = optimalRouteTimeDiff / results_custom_speed_default_route[i,3] * 100
      timeDeltaFrame = rbind(timeDeltaFrame, data.frame(id = results_custom_speed_default_route[i,1], timeDelta = optimalRouteTimeDiff, percentageTimeProfit = percentageTimeDiff))
    }
  }
  
}
#results grouped by route time
routeTimeGroup1 = subset(timeDeltaFrame, timeDelta > 0 & timeDelta <= 25000)
summary(routeTimeGroup1)
routeTimeGroup2 = subset(timeDeltaFrame, timeDelta > 25000 & timeDelta <= 50000)
summary(routeTimeGroup2)
routeTimeGroup3 = subset(timeDeltaFrame, timeDelta > 50000 & timeDelta <= 100000)
summary(routeTimeGroup3)
routeTimeGroup4 = subset(timeDeltaFrame, timeDelta > 100000 & timeDelta <= 150000)
summary(routeTimeGroup4)
routeTimeGroup5 = subset(timeDeltaFrame, timeDelta > 150000)
summary(routeTimeGroup5)
#END - grouping routes by time profit

timespans <- read.table("/home/lukasz/Pulpit/Results_WAW_Bridges4/timespans2.txt", header = FALSE)
routes_through_bridges = 0

for (i in 1:length(timespans$V1)) {

  timespan = timespans[i,1]
  bridges_real <- read.table(paste0("/home/lukasz/Pulpit/Results_WAW_Bridges5/results_custom_speed_default_route_wo_parking_", timespan, "_bridges_real.txt"), header = FALSE)
  bridges_blind <- read.table(paste0("/home/lukasz/Pulpit/Results_WAW_Bridges5/results_custom_speed_default_route_wo_parking_", timespan, "_bridges_blind.txt"), header = FALSE)
  bridges_traffic <- read.table(paste0("/home/lukasz/Pulpit/Results_WAW_Bridges5/results_custom_speed_custom_route_wo_parking_", timespan, "_bridges_traffic.txt"), header = FALSE)
  
  bridges_real_frame <- data.frame(id=integer(), bridge_id=integer(), date=character(), start_time=character(), end_time=character())
  for (i in 1:length(bridges_real$V1)) {
    bridges_real_frame = rbind(bridges_real_frame, data.frame(id = bridges_real[i, 1], bridge_id = bridges_real[i, 2], date = bridges_real[i, 3],
                                                              start_time = bridges_real[i, 4], end_time = bridges_real[i, 8]))
  }
  
  bridges_real_frame = unique(bridges_real_frame)
  bridges_blind = unique(bridges_blind)
  bridges_traffic = unique(bridges_traffic)
  
  routes_through_bridges = routes_through_bridges + nrow(bridges_real_frame)
  
  blind_matches = 0
  traffic_matches = 0
  other = 0
  
  for (i in 1:length(bridges_real_frame$id)) {
    real_route_id = bridges_real_frame[i,1]
    real_bridge_id = bridges_real_frame[i,2]
    if (real_bridge_id != 2) { #condition for investigating routes after Lazienkowski bridge fire in order to discard dirty data
      bridges_blind_matched_row = bridges_blind[bridges_blind$V1 == real_route_id,]
      bridges_traffic_mathced_row = bridges_traffic[bridges_traffic$V1 == real_route_id,]
      blind_bridge_id = bridges_blind_matched_row$V2
      traffic_bridge_id = bridges_traffic_mathced_row$V2
  
      is_in_group = routeTimeGroup5[routeTimeGroup5$id==real_route_id,] # optional condition to calculate coverage delta
      if (!invalid(is_in_group)) {
        if (!invalid(blind_bridge_id) & !invalid(traffic_bridge_id)) {
          
          #printing results to one file
          cat(paste(bridges_real_frame[i, 1], bridges_real_frame[i, 2], bridges_real_frame[i, 3],
                    bridges_real_frame[i, 4], bridges_real_frame[i, 5],
                    bridges_blind_matched_row$V2, bridges_blind_matched_row$V3, bridges_blind_matched_row$V4,
                    bridges_traffic_mathced_row$V2, bridges_traffic_mathced_row$V3, bridges_traffic_mathced_row$V4),
              file="/home/lukasz/Pulpit/output3.txt", sep="\n", append=TRUE)
          #END - printing results to one file
          
          if (blind_bridge_id != traffic_bridge_id) {
            if (real_bridge_id == blind_bridge_id) {
              blind_matches = blind_matches + 1
              print(paste("b ", real_route_id))
            } else if (real_bridge_id == traffic_bridge_id) {
              traffic_matches = traffic_matches + 1
              print(paste("t ", real_route_id))
            } else {
              other = other + 1
              print(paste("o ", real_route_id))
            }
          }
        }
      }
    }
  }
  print(paste(timespan, " - Blind: ", blind_matches, ", Traffic: ", traffic_matches, ", Other: ", other))
  cat(paste(timespan, blind_matches, traffic_matches, other), file="/home/lukasz/Pulpit/output.txt", sep="\n", append=TRUE)
}

