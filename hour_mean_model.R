# load train and test data
train <- read.csv("Data/train.csv", stringsAsFactors=FALSE)
test <- read.csv("Data/test.csv", stringsAsFactors=FALSE)

train$hour <- factor(format(as.POSIXct(train$datetime, format="%Y-%m-%d %H:%M"), format="%H"))
test$hour <- factor(format(as.POSIXct(test$datetime, format="%Y-%m-%d %H:%M"), format="%H"))

hour_mean <- aggregate(count ~ hour, data=train, mean)
merged <- merge(test, hour_mean, 'hour')

merged <- merged[order(merged$datetime),]

# Create submission dataframe and output to file
submit <- data.frame(datetime = merged$datetime, count = merged$count)
write.csv(submit, file = "Output/hour_mean_model.csv", row.names = FALSE)
