# load dependencies
library(rpart)

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

reg_fit <- rpart(registered ~ hour + month + year + weekday + weather + atemp +
               workingday + holiday + windspeed + humidity + season, data=train, control=rpart.control(minsplit=2, cp=0))

reg_prediction <- predict(reg_fit, test, type = "matrix")

casual_fit <- rpart(casual ~ hour + month + year + weekday + weather + atemp +
                   workingday + holiday + windspeed + humidity + season, data=train, control=rpart.control(minsplit=2, cp=0))

casual_prediction <- predict(casual_fit, test, type = "matrix")

# Create submission dataframe and output to file
submit <- data.frame(datetime = test$datetime, count = reg_prediction + casual_prediction)
write.csv(submit, file = "Output/separate_decision_trees.csv", row.names = FALSE)
