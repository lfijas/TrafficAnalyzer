#db connection
library(RMySQL)
mydb = dbConnect(MySQL(), user='root', password='admin', dbname='yanosik', host='localhost')

#script 1
latMargin = 0.00005
longMargin = 0.00007

timeDiffs = c()
for (id in 1:1000) {
  print(paste("Id", id))
  #resultSet = dbSendQuery(mydb, paste("select Id, Date, Longitude, Latitude from Traffic where Id = 12 order by Date"))
  resultSet = dbSendQuery(mydb, paste("select Id, Date, Longitude, Latitude from Traffic where Id =", id ,"order by Date"))
  data = fetch(resultSet, n = -1)
  groupBeginningIndex = 1
  count = nrow(data)
  if (count > 1) {
    for (i in 2:nrow(data)) {
      longDiff = abs(data[i, 3] - data[groupBeginningIndex, 3])
      latDiff = abs(data[i, 4] - data[groupBeginningIndex, 4]) 
      if (latDiff > latMargin  || longDiff > longMargin) {
        if (i - groupBeginningIndex > 1) {
          timeDiffs = append(timeDiffs, as.numeric(difftime(as.POSIXlt(data[i, 2], tz = ""),
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
hist(timeDiffs, breaks = seq(0, max(timeDiffs) + 10, by = 10), xlim = c(0, 1000), col="cornflowerblue")
hist(timeDiffs, breaks = seq(0, max(timeDiffs) + 10, by = 10), xlim = c(0, 200), col="green")
#hist(timeDiffs, freq = FALSE, breaks = seq(0, max(timeDiffs), by = 1))
#hist(timeDiffs, freq = FALSE, breaks = seq(0, max(timeDiffs), by = 1), xlim = c(0, 50))

