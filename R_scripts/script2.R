#db connection
library(RMySQL)
mydb = dbConnect(MySQL(), user='root', password='admin', dbname='yanosik', host='localhost')

#script 1 - calculating stops length 
latMargin = 0.00005
longMargin = 0.00007

timeDiffs = c()
for (id in 1:1000) {
  print(paste("Id", id))
  #resultSet = dbSendQuery(mydb, paste("select Id, Date, Longitude, Latitude from Traffic where Id = 12 order by Date"))
  resultSet = dbSendQuery(mydb, paste("select Id, Date, Longitude, Latitude from Traffic_with_speed where Id =", id ," and Tag = 'WAW' order by Date"))
  data = fetch(resultSet, n = -1)
  groupBeginningIndex = 1
  count = nrow(data)
  if (count > 1) {
    for (i in 2:nrow(data)) {
      longDiff = abs(data[i, 3] - data[groupBeginningIndex, 3])
      latDiff = abs(data[i, 4] - data[groupBeginningIndex, 4]) 
      if (latDiff > latMargin  || longDiff > longMargin) {
        if (i - groupBeginningIndex > 1) {
          timeDiffs = append(timeDiffs, as.numeric(difftime(as.POSIXlt(data[i - 1, 2], tz = ""),
                                                            as.POSIXlt(data[groupBeginningIndex, 2], tz = ""), units = "secs")))
        }
        groupBeginningIndex = i
      
      }
    }
  }
}
timeDiffs = timeDiffs[!is.na(timeDiffs)]
#hist(timeDiffs, breaks = seq(0, max(timeDiffs), by = 1), xlim = c(0, 50))
hist(timeDiffs, breaks = seq(0, max(timeDiffs), by = 1), xlim = c(0, max(timeDiffs)))
hist(timeDiffs, breaks = seq(0, max(timeDiffs) + 10, by = 10), xlim = c(0, max(timeDiffs)))
hist(timeDiffs, breaks = seq(0, max(timeDiffs) + 10, by = 10), xlim = c(0, 1000), col="cornflowerblue",
     xlab = "Długość postoju w sekundach", ylab = "Ilość postojów", main="")
hist(timeDiffs, breaks = seq(0, max(timeDiffs) + 10, by = 10), xlim = c(0, 200), col="cornflowerblue", 
     xlab = "Długość postoju w sekundach", ylab = "Ilość postojów", main="")
#hist(timeDiffs, freq = FALSE, breaks = seq(0, max(timeDiffs), by = 1))
#hist(timeDiffs, freq = FALSE, breaks = seq(0, max(timeDiffs), by = 1), xlim = c(0, 50))

#script 2 - splitting the route if stopping the car is detected
#TODO - sprawidzić dlaczego przejazd o id 42829 nie został zapisany do tabeli Traffic without parking
latMargin = 0.00005
longMargin = 0.00007
PARKING_TIME = 60

trafficWithoutParkingId = 25966
for (id in 1:1000) {
  print(paste("Id", id))
  resultSet = dbSendQuery(mydb, paste("select Id, Date, Longitude, Latitude, Tag from Traffic_with_speed where Id =", id ," and Tag = 'WAW' order by Date"))
  data = fetch(resultSet, n = -1)
  groupBeginningIndex = 1
  count = nrow(data)
  if (count > 1) {
    routeStartIndex = 1
    for (i in 2:count) {
      longDiff = abs(data[i, 3] - data[groupBeginningIndex, 3])
      latDiff = abs(data[i, 4] - data[groupBeginningIndex, 4]) 
      if (latDiff > latMargin  || longDiff > longMargin) {
        timeDiff = as.numeric(difftime(as.POSIXlt(data[i, 2], tz = ""),
                                                          as.POSIXlt(data[groupBeginningIndex, 2], tz = ""), units = "secs"))
        if (timeDiff > PARKING_TIME) {
          ###option 1###
          #queries <- paste("insert into Traffic_without_parking 
          #                 values(", trafficWithoutParkingId, ", ", data[routeStartIndex:groupBeginningIndex, 1], ", '", data[routeStartIndex:groupBeginningIndex, 2], "', ", data[routeStartIndex:groupBeginningIndex, 3], ", ", data[routeStartIndex:groupBeginningIndex, 4], ", 'WAW')")
          #for (query in queries) {
          #  dbGetQuery(mydb, query)
          #}
          ###option 1 END###
          ###option 2###
          query = "insert into Traffic_without_parking values"
          for (j in routeStartIndex:groupBeginningIndex) {
            query <- paste(query, "(", trafficWithoutParkingId, ", ", data[j, 1], ", '", data[j, 2], "', ", data[j, 3], ", ", data[j, 4], ", 'WAW'),")              
          }
          dbGetQuery(mydb, substr(query, 1, nchar(query) - 1))
          ###option 2 END###
          trafficWithoutParkingId = trafficWithoutParkingId + 1
          
          routeStartIndex = i
        }
      groupBeginningIndex = i
      }
    }
    ###option 1###
    #queries <- paste("insert into Traffic_without_parking 
    #                         values(", trafficWithoutParkingId, ", ", data[routeStartIndex:count, 1], ", '", data[routeStartIndex:count, 2], "', ", data[routeStartIndex:count, 3], ", ", data[routeStartIndex:count, 4], ", 'WWW')")
    #for (query in queries) {
    #  dbGetQuery(mydb, query)
    #}
    ###option 1 END###
    ###option 2###
    query = "insert into Traffic_without_parking values"
    for (j in routeStartIndex:count) {
      query <- paste(query, "(", trafficWithoutParkingId, ", ", data[j, 1], ", '", data[j, 2], "', ", data[j, 3], ", ", data[j, 4], ", 'WWW'),")              
    }
    dbGetQuery(mydb, substr(query, 1, nchar(query) - 1))
    ###option 2 END###
    trafficWithoutParkingId = trafficWithoutParkingId + 1
  }
}

          