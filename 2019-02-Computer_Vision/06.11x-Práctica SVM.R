
# Clasificación Support Vector Machine

library(caret)
library(e1071)

train <- read.csv("train.csv", header = T)

train$label <- as.factor(train$label)

nvz.default <- nearZeroVar(train[, -1])
train.postnvz <- train[, -1]
train.postnvz <- train.postnvz[, -nvz.default]
train.preproc <- preProcess(train.postnvz, method = c("pca"))

train.transform <- predict( train.preproc, train.postnvz)

set.seed(666)

inTrain <- createDataPartition(train$label, p = .8, list = F)
training <- cbind(train$label[inTrain], train.transform[inTrain,])
testing <- cbind(train$label[-inTrain], train.transform[-inTrain,])
names(training)[1] <- "label"
names(testing)[1] <- "label"

modelo.SVM <- svm(label ~ ., data = training)

prediccion.SVM <- predict(modelo.SVM, newdata = testing)

confusionMatrix(prediccion.SVM, testing$label)

# Accuracy / Precisión: 0.9721

# Single Value Decomposition ----------------------------------

library(irlba)

svd <- irlba(as.matrix(train[,-1]), nv = 40, nu = 40)

train.postsvd <- as.data.frame(as.matrix(train[,-1]) %*% svd$v)

inTrain <- createDataPartition(train$label, p = .8, list = F)
training <- cbind(label = train$label[inTrain], train.postsvd[inTrain,])
testing <- cbind(label = train$label[-inTrain], train.postsvd[-inTrain,])


modelo.SVM <- svm(label ~ ., data = training)

prediccion.SVM <- predict(modelo.SVM, newdata = testing)

confusionMatrix(prediccion.SVM, testing$label)

# Accuracy / Precisión: 0.9784
