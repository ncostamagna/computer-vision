library(kernlab)
library(caret)
data(spam)

table(spam$type)

inTrain <- createDataPartition(y = spam$type, p = .75, list = F)

training <- spam[inTrain,]
testing <- spam[-inTrain,]

modelFit <- train(type ~ ., data = training, method = "glm")

predictions <- predict(modelFit, newdata = testing)

confusionMatrix(predictions, testing$type)

