# load train and test data
train <- read.csv("Data/train.csv", stringsAsFactors=FALSE)
test <- read.csv("Data/test.csv", stringsAsFactors=FALSE)

train$hour <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%H"))
train$month <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%B"))
train$weekday <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%u"))
train$year <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%y"))

test$hour <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%H"))
test$month <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%B"))
test$weekday <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%u"))
test$year <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%y"))

hour_month_wday_year_mean <- aggregate(count ~ hour + month + weekday + year, data=train, mean)
merged <- merge(test, hour_month_wday_year_mean, by=c('hour', 'month', 'weekday', 'year'))

merged <- merged[order(merged$datetime),]

# Create submission dataframe and output to file
submit <- data.frame(datetime = merged$datetime, count = merged$count)
write.csv(submit, file = "Output/hour_month_weekday_year_model.csv", row.names = FALSE)
