# load dependencies
library(randomForest)

# load train and test data
train <- read.csv("Data/train.csv", stringsAsFactors=FALSE)
test <- read.csv("Data/test.csv", stringsAsFactors=FALSE)

# create useable data from datetime
train$hour <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%H"))
train$month <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%B"))
train$weekday <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%u"))
train$year <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%y"))
test$hour <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%H"))
test$month <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%B"))
test$weekday <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%u"))
test$year <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%y"))

set.seed(415)
casual_fit <- randomForest(as.factor(casual) ~ hour + month + year + weekday + weather + atemp +
                      workingday + holiday + windspeed + humidity + season, data=train, ntree = 700, importance=TRUE)
registered_fit <- randomForest(as.factor(registered) ~ hour + month + year + weekday + weather + atemp +
                      workingday + holiday + windspeed + humidity + season, data=train, ntree = 700, importance=TRUE)


casual_prediction <- predict(casual_fit, test)
registered_prediction <- predict(registered_fit, test)

# Create submission dataframe and output to file
submit <- data.frame(datetime = test$datetime, count = as.numeric(casual_prediction) + as.numeric(registered_prediction))
write.csv(submit, file = "Output/separate_random_forests.csv", row.names = FALSE)

