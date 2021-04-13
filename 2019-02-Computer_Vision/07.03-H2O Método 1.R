
# Clasificaci?n con H2O
# install.packages('h2o')
# install.packages('caret')
# install.packages('e1071')

library(h2o)
library(caret)
library(e1071)

train <- read.csv("computer_vision_01/datos/5/train.csv", header = T)

#Convertimos a factor
train$label <- as.factor(train$label)

set.seed(666)

inTrain <- createDataPartition(train$label, p=0.8, list = F)
training <- train[inTrain,]
testing <- train[-inTrain,]

#Inicializamos H20 en localhost
local.h2o <- h2o.init(ip = 'localhost', port = 54321, startH2O = T, nthreads = 1)

training.h2o <- as.h2o(training)
testing.h2o <- as.h2o(testing)

# x -> predictor
# y -> lo que queremos saber
# training.h2o -> dataframe que vamos a entrenar
# hidden = rep(160,5) -> 5 niveles de 160 neuronas cada una
# epochs -> numero de interacciones para formar la rn
modelo.H2O <- h2o.deeplearning(x = 2:785, y = 1, training.h2o, activation = 'Tanh',
                               hidden = rep(160,5), epochs = 20)

# Modelo y datos de entrenamiento
prediccion.H2O <- h2o.predict(modelo.H2O, newdata = testing.h2o[,-1])
prediccion.H2O.df <- as.data.frame(prediccion.H2O)

# confusion Matriz, ver el resultado del modelo
confusionMatrix(prediccion.H2O.df$predict, testing[,1])

# Accuracy/Precisi?n: 0.9647451

h2o.shutdown(prompt = F)
