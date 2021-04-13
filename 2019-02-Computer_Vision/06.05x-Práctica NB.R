
# Clasificador Naïve Bayes

library(e1071) 
library(caret)

set.seed(666)

train <- read.csv("train.csv", header = T)

inTrain <- createDataPartition(train$label, p = 0.8, list = F)
training <- train[inTrain,]
testing <- train[-inTrain,]


training$label <- as.factor(training$label)
testing$label <- as.factor(testing$label)


modelo.NaiveBayes <- naiveBayes(training$label ~ ., data = training)

prediccion.NaiveBayes <- predict(modelo.NaiveBayes, newdata = testing, type = "class")

confusionMatrix(prediccion.NaiveBayes, testing$label)

#Precisión Normal = 0.5347

# Near Zero Values --------------------------------------------------

nzv.default <- nearZeroVar(train[,-1])
train.postnzv <- train[,-1]
train.postnzv <- train.postnzv[, -nzv.default]

inTrain <- createDataPartition(train$label, p = 0.8, list = F)
training <- cbind(label = train[inTrain,1], train.postnzv[inTrain,])
testing <- cbind(label = train[-inTrain,1], train.postnzv[-inTrain,])


training$label <- as.factor(training$label)
testing$label <- as.factor(testing$label)

modelo.NaiveBayes.NZV <- naiveBayes(training$label ~ ., data = training)

prediccion.NaiveBayes.NZV <- predict(modelo.NaiveBayes.NZV, newdata = testing[,-1], type = "class")

confusionMatrix(prediccion.NaiveBayes.NZV, testing$label)

# Precisión NZV = 0.8239

#´ Principal Component Analysis ----------------------------------------

train.preproc <- preProcess(train[,-1], method = c("pca"))

# No se puede calcular PCA con predictores de varianza 0

train.preproc <- preProcess(train.postnzv, method = c("pca"))
train.transform <- predict(train.preproc, train.postnzv)

inTrain <- createDataPartition(train$label, p = 0.8, list = F)
training <- cbind(label = train[inTrain,1], train.transform[inTrain,])
testing <- cbind(label = train[-inTrain,1], train.transform[-inTrain,])


training$label <- as.factor(training$label)
testing$label <- as.factor(testing$label)

modelo.NaiveBayes.PCA <- naiveBayes(training$label ~ ., data = training)

prediccion.NaiveBayes.PCA <- predict(modelo.NaiveBayes.PCA, newdata = testing[,-1], type = "class")

confusionMatrix(prediccion.NaiveBayes.PCA, testing$label)

# Precisión NZV + PCA = 0.8695
