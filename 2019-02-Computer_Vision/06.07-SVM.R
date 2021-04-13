
# Clasificacisn Support Vector Machine

library(caret)
library(e1071) # SVM que esta aqui

train <- read.csv("J:\\Cursos\\2017-Udemy\\2019-02-Computer_Vision\\datos\\5\\train.csv", header = T)

#Factorizar los labels
train$label <- as.factor(train$label)

train

### Eliminar todos los predictores con varianza cercana a cero, todo lo que no tiene informacion
nvz.default <- nearZeroVar(train[, -1])
train.postnvz <- train[, -1] #quitamos etiqueta
train.postnvz <- train.postnvz[, -nvz.default] #Solo cargaremos columnas que no esten en nvz
train.preproc <- preProcess(train.postnvz, method = c("pca")) #Cargamos componentes principales
train.transform <- predict( train.preproc, train.postnvz) #Prediccion de los compoentes principales

train.preproc

set.seed(666)


#Volvemos a agregar el label
inTrain <- createDataPartition(train$label, p = .8, list = F)
training <- cbind(train$label[inTrain], train[inTrain,]) #cbind-> juntar en columnas 2 data set
testing <- cbind(train$label[-inTrain], train[-inTrain,])
names(training)[1] <- "label"
names(testing)[1] <- "label"

pc <- proc.time()
?svm
modelo.SVM <- svm(label ~ ., data = training) #label ~ . -> label frente a todas las demas q no son label
proc.time() - pc

modelo.SVM

#modelo.SVM -> modelo que vamos a tener para poder realizar predicciones
prediccion.SVM <- predict(modelo.SVM, newdata = testing[,-1])


confusionMatrix(prediccion.SVM, testing$label)
# Muy buena prediccion
# Accuracy / PrecisiC3n: 0.9721
