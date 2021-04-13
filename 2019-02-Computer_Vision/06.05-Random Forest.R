
# ClasificaciC3n Random Forest

library (caret)

train <- read.csv("D:\\Cursos\\2017-Udemy\\2019-02-Computer_Vision\\datos\\5\\train.csv", header = T)
#Colocamos label como factor
train$label <- as.factor(train$label)

#Dimension
dim(train)

#valores cuya varianza sean 0 o esten cercanas a 0, las quitamos
nvz.default <- nearZeroVar(train[,-1])
train.postnvz <- train[,-1]
train.postnvz <- train.postnvz[,-nvz.default]

train.preproc <- preProcess(train.postnvz, method = c("pca"))

train.transform <- predict(train.preproc, train.postnvz)

train.transform

?predict

library(randomForest)

set.seed(666)

#p= .8 80% de los datos
inTrain <- createDataPartition(train$label, p = .8, list = F)
training <- train.transform[inTrain,]
testing <- train.transform[-inTrain,]

pc <- proc.time()
modelo.RandomForest <- randomForest(training, train[inTrain,1], ntree = 500)
proc.time() - pc

modelo.RandomForest

prediccion.RandomForest <- predict(modelo.RandomForest, newdata = testing, type = 'class')

confusionMatrix(prediccion.RandomForest, train$label[-inTrain])

# Accuracy/PrecisiC3n = 0.9446

# Random Forest con el paquete Caret

pc <- proc.time()
modelo.RandomForest.Caret <- train(training, train[inTrain,1], method = 'rf')
proc.time() - pc

prediccion.RandomForest.Caret <- predict(modelo.RandomForest.Caret, newdata = testing, type = 'raw')

confusionMatrix(prediccion.RandomForest.Caret, train$label[-inTrain])

# Accuracy/PrecisiC3n: 0.9433

