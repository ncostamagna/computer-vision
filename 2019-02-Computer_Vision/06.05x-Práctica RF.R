
# Clasificación Random Forest

library (caret)

train <- read.csv("train.csv", header = T)
train$label <- as.factor(train$label)

nvz.default <- nearZeroVar(train[,-1])
train.postnvz <- train[,-1]
train.postnvz <- train.postnvz[,-nvz.default]

train.preproc <- preProcess(train.postnvz, method = c("pca"))

train.transform <- predict(train.preproc, train.postnvz)

library(randomForest)

set.seed(666)

inTrain <- createDataPartition(train$label, p = .8, list = F)
training <- train.transform[inTrain,]
testing <- train.transform[-inTrain,]

modelo.RandomForest <- randomForest(training, train[inTrain,1], ntree = 500)

prediccion.RandomForest <- predict(modelo.RandomForest, newdata = testing, type = 'class')

confusionMatrix(prediccion.RandomForest, train$label[-inTrain])

# Accuracy/Precisión = 0.9446

# Número de árboles = 200 -----------------------------------------

modelo.RandomForest <- randomForest(training, train[inTrain,1], ntree = 200)

prediccion.RandomForest <- predict(modelo.RandomForest, newdata = testing, type = 'class')

confusionMatrix(prediccion.RandomForest, train$label[-inTrain])

# Accuracy/Precisión = 0.9444

# Número de árboles = 800 -----------------------------------------

modelo.RandomForest <- randomForest(training, train[inTrain,1], ntree = 800)

prediccion.RandomForest <- predict(modelo.RandomForest, newdata = testing, type = 'class')

confusionMatrix(prediccion.RandomForest, train$label[-inTrain])

# Accuracy/Precisión = 0.9456