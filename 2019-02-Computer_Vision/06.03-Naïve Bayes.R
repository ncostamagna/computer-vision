
# Clasificador Naive Bayes

library(tidyverse)
library(e1071) 
# https://cran.r-project.org/web/packages/e1071/index.html

??e1071
library(caret)

#Establecer una semilla, que los numeros que se generen aleatoriamente se generen iguales, para que podamos realizarlos todos
set.seed(666)

train <- read.csv("D:\\Cursos\\2017-Udemy\\2019-02-Computer_Vision\\datos\\5\\train.csv", header = T)

#Todas las variables seleccionadas dentro de ese %80, las que no estan vamos a usarlas para testear
inTrain <- createDataPartition(train$label, p = 0.8, list = F)
#Las que estan en ese %80
training <- train[inTrain,]
#Las que no estan
testing <- train[-inTrain,]

#Que sean de tipo clase o factor y no Numerica
training$label <- as.factor(training$label)
testing$label <- as.factor(testing$label)

#Observar el tiempo
pc <- proc.time()
#Realizar entrenamiento
modelo.NaiveBayes <- naiveBayes(training$label ~ ., data = training)
proc.time() - pc

summary(modelo.NaiveBayes)

#Prediccion en base a los datos de pruebas
prediccion.NaiveBayes <- predict(modelo.NaiveBayes, newdata = testing, type = "class")

table(testing$label)
confusionMatrix(prediccion.NaiveBayes, testing$label)

#Accuracy/Precision: 0.5347

## Guardamos el modelo
save(modelo.NaiveBayes, file = "modelo.NaiveBayes.rda")


# Naive Bayes con Caret

pc <- proc.time()
#x -> dataset predictores
#y -> dataset de clases
#metodo -> Naive Bayes
#trainControl -> numero 10 por 10 clases
modelo.NaiveBayes.Caret <- train(training[,-1], training$label, method = 'nb',
                                 trControl = trainControl(method = 'cv', number = 10))
proc.time() - pc

prediccion.NaiveBayes.Caret <- predict(modelo.NaiveBayes.Caret, newdata = testing, type = "raw")

confusionMatrix(prediccion.NaiveBayes.Caret, testing[,1])

# Accuracy/PrecisiC3n: 0.3939
