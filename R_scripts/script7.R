library(tidyverse)
library(class)
library(gplots)
library(gmodels)
library(caret)

### knn
traffic <- read.csv('/Users/lukasz/Documents/Mgr/bridges_5_classification.csv')
traffic <- subset(traffic, traffic$X.1 == "KEEP")
traffic[, 14] <- NULL
traffic[, 13] <- NULL
traffic[, 11] <- NULL
traffic[, 10] <- NULL
traffic[, 7] <- NULL
traffic[, 4] <- NULL
traffic[, 3] <- NULL
traffic[, 2] <- NULL
traffic[, 1] <- NULL

traffic <- mlr::createDummyFeatures(traffic, target = 'X', method = '1-of-n')

set.seed(214)
index <- createDataPartition(traffic$X, p = .7, list = FALSE)

traffic_gat_train <- traffic[index, 5]
traffic_train <- traffic[index, -5]

traffic_gat_test <- traffic[-index, 5]
traffic_test <- traffic[-index, -5]

ctrl <- trainControl(method = "cv", number = 10)

knnFit <- train(traffic_train, 
                traffic_gat_train, 
                method = "knn", 
                trControl = ctrl, 
                preProcess = c("center","scale"), 
                tuneLength = 1)

knnFit <- train(traffic_train, 
                traffic_gat_train, 
                method = "knn", 
                trControl = ctrl, 
                preProcess = c("center","scale"), 
                tuneGrid = expand.grid(k = 1:50))

print(knnFit)

plot(knnFit, xlab = "Wartość hiperparametru k", ylab = "Dokładność modelu")
knnFit$finalModel

knnPredict <- predict(knnFit, newdata = traffic_test )

confusionMatrix(knnPredict, traffic_gat_test)

### Naive Bayes
traffic <- read.csv('/Users/lukasz/Documents/Mgr/bridges_5_classification.csv')
traffic <- subset(traffic, traffic$X.1 == "KEEP")
traffic[, 14] <- NULL
traffic[, 13] <- NULL
traffic[, 11] <- NULL
traffic[, 10] <- NULL
traffic[, 7] <- NULL
traffic[, 4] <- NULL
traffic[, 3] <- NULL
traffic[, 2] <- NULL
traffic[, 1] <- NULL

traffic[, 6] <- NULL

traffic <- mlr::createDummyFeatures(traffic, target = 'X', method = '1-of-n')

traffic[,1:4] <- scale(traffic[,1:4])

set.seed(214)
index <- createDataPartition(traffic$X, p = .7, list = FALSE)

traffic_gat_train <- traffic[index, 5]
traffic_train <- traffic[index, -5]

traffic_gat_test <- traffic[-index, 5]
traffic_test <- traffic[-index, -5]

ctrl <- trainControl(method = 'repeatedcv',
                     number = 10, repeats = 3, 
                     verboseIter = T, search = 'random')

model <- caret::train(traffic_train, traffic_gat_train, 
               method = 'nb',
               trControl = ctrl,
               tuneLength = 5)
model
pred <- predict(model, traffic_test)
caret::confusionMatrix(pred, traffic_gat_test)


### Decision trees
traffic <- read.csv('/Users/lukasz/Documents/Mgr/bridges_5_classification.csv')
traffic <- subset(traffic, traffic$X.1 == "KEEP")
traffic[, 14] <- NULL
traffic[, 13] <- NULL
traffic[, 11] <- NULL
traffic[, 10] <- NULL
traffic[, 7] <- NULL
traffic[, 4] <- NULL
traffic[, 3] <- NULL
traffic[, 2] <- NULL
traffic[, 1] <- NULL

traffic <- mlr::createDummyFeatures(traffic, target = 'X', method = '1-of-n')

traffic[,1:4] <- scale(traffic[,1:4])

set.seed(214)
index <- createDataPartition(traffic$X, p = .7, list = FALSE)

traffic_gat_train <- traffic[index, 5]
traffic_train <- traffic[index, -5]

traffic_gat_test <- traffic[-index, 5]
traffic_test <- traffic[-index, -5]

cross.walid <- trainControl(method = "cv",
                            number = 10,
                            search = 'grid',
                            verboseIter = T,
                            classProbs = TRUE, 
                            summaryFunction = multiClassSummary)

siatka <- expand.grid(model = 'tree',
                      winnow = F,
                      trials = seq(1, 10, by = 1)) 

model <- caret::train(traffic_train,
                      traffic_gat_train,
                      trControl = cross.walid, 
                      tuneGrid = siatka,
                      method = 'C5.0')
model
plot(model, xlab = "Liczba iteracji boostingu", ylab = "Dokładność modelu")

pred <- predict(model, traffic_test, type = 'raw')
caret::confusionMatrix(traffic_gat_test, pred)
