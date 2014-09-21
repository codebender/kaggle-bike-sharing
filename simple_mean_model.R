# load train and test data
train <- read.csv("Data/train.csv", stringsAsFactors=FALSE)
test <- read.csv("Data/test.csv", stringsAsFactors=FALSE)

# Create submission dataframe and output to file
submit <- data.frame(datetime = test$datetime, count = mean(train$count))
write.csv(submit, file = "Output/simple_mean_model.csv", row.names = FALSE)
