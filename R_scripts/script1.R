#db connection
library(RMySQL)
mydb = dbConnect(MySQL(), user='root', password='admin', dbname='yanosik', host='localhost')

#script 1
timeDiffs = c()
for (id in 1:10) {
  print(paste("Id", id))
  #resultSet = dbSendQuery(mydb, paste("select Id, Date from Traffic where Id = 12 order by Date"))
  resultSet = dbSendQuery(mydb, paste("select Id, Date from Traffic where Id =", id ,"order by Date"))
  data = fetch(resultSet, n = -1)
  for (i in 2:nrow(data)) {
    timeDiffs = append(timeDiffs, as.numeric(difftime(as.POSIXlt(data[i, 2], tz = ""),
                              as.POSIXlt(data[i - 1, 2], tz = ""), units = "secs")))
  }
}
timeDiffs = timeDiffs[!is.na(timeDiffs)]
hist(timeDiffs, breaks = seq(0, max(timeDiffs), by = 1), xlim = c(0, 50))
hist(timeDiffs, breaks = seq(0, max(timeDiffs), by = 1), xlim = c(0, max(timeDiffs)))
hist(timeDiffs, freq = FALSE, breaks = seq(0, max(timeDiffs), by = 1))
hist(timeDiffs, freq = FALSE, breaks = seq(0, max(timeDiffs), by = 1), xlim = c(0, 50))

#script 2
journeysLengths = c()
for (id in 1: 100) {
  print(paste("Id", id))
  resultSet = dbSendQuery(mydb, paste("select Id, Date from Traffic where Id =", id ,"order by Date"))
  data = fetch(resultSet, n = -1)
  count = nrow(data)
  if (count > 0) {
    journeysLengths = append(journeysLengths, as.numeric(difftime(as.POSIXlt(data[count, 2], tz = ""),
                                                            as.POSIXlt(data[1, 2], tz = ""), units = "secs")))
  }
}
journeysLengths = journeysLengths[!is.na(journeysLengths)]
hist(journeysLengths)

#script 3
#resultSet = dbSendQuery(mydb, "SELECT Id, COUNT(*) FROM Traffic GROUP BY Id")
resultSet = dbSendQuery(mydb, "SELECT Id, COUNT(*) FROM Traffic_without_parking GROUP BY Id")
data = fetch(resultSet, n = -1)
hist(data[, 2], breaks = seq(0, max(data[, 2]), by = 1), xlim = c(0, 100))

#script 4
maxTimeDiffs = c()
for (id in 1:20) {
  print(paste("Id", id))
  resultSet = dbSendQuery(mydb, paste("select Id, Date from Traffic where Id =", id ,"order by Date"))
  data = fetch(resultSet, n = -1)
  maxTimeDiff = 0
  count = nrow(data)
  if (count > 1) {
    for (i in 2:count) {
      timeDiff = as.numeric(difftime(as.POSIXlt(data[i, 2], tz = ""),
                                                        as.POSIXlt(data[i - 1, 2], tz = ""), units = "secs"))
      if (timeDiff > maxTimeDiff) {
        maxTimeDiff = timeDiff
      }
    }
    maxTimeDiffs = append(maxTimeDiffs, maxTimeDiff)
  }
}
maxTimeDiffs = maxTimeDiffs[!is.na(maxTimeDiffs)]
hist(maxTimeDiffs, breaks = seq(0, max(maxTimeDiffs), by = 1), xlim = c(0, 100))
hist(maxTimeDiffs, freq = FALSE, breaks = seq(0, max(maxTimeDiffs), by = 30))

