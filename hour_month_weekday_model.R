# load train and test data
train <- read.csv("Data/train.csv", stringsAsFactors=FALSE)
test <- read.csv("Data/test.csv", stringsAsFactors=FALSE)

train$hour <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%H"))
train$month <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%B"))
train$weekday <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%u"))

test$hour <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%H"))
test$month <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%B"))
test$weekday <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%u"))

hour_month_wday_mean <- aggregate(count ~ hour + month + weekday, data=train, mean)
merged <- merge(test, hour_month_wday_mean, by=c('hour', 'month', 'weekday'))

merged <- merged[order(merged$datetime),]

# Create submission dataframe and output to file
submit <- data.frame(datetime = merged$datetime, count = merged$count)
write.csv(submit, file = "Output/hour_month_weekday_model.csv", row.names = FALSE)
