
# H2O - Cuello de Botella
# install.packages('h2o')
# install.packages('caret')
# install.packages('e1071')

library(h2o)
library(caret)

train <- read.csv("computer_vision_01/datos/5/train.csv", header = T)

train$label <- as.factor(train$label)

set.seed(666)

inTrain <- createDataPartition(train$label, p = .8, list = F)
training <- train[inTrain,]
testing <- train[-inTrain,]

# nthreads = -1 -> dejamos a eleccion de H20 ir abriendo hilos a media que los va necesitando
local.h2o <- h2o.init(ip = 'localhost', port = 54321, startH2O = T, nthreads = -1)

training.H2O <- as.h2o(training)
testing.H2O <- as.h2o(testing)

# Cuello de botella o bottlenelr, 5 capas ocultas de 400-200-2-200-400,
# en el punto donde hay 2 neuronas es donde se hace el cuello de botella, 
# reduciendo dimencionalidad, definimos un valor y, es supervisado
model.h2o <- h2o.deeplearning(x = 2:785, y = 1, training.H2O, activation = 'Tanh',
                              hidden = c(400, 200, 2, 200, 400), epochs = 20)

prediccion.H2O <- h2o.predict(modelo.H2O, newdata = testing.H2O[,-1])
prediccion.H2O.df <- as.data.frame(prediccion.H2O)

confusionMatrix(prediccion.H2O.df$predict, testing[,1])

#Accuracy/Precisi?n = 0.9369938

# hacemos otro modelo pero NO supervisado, no le damos el valor de y
# autoencoder = T -> no sabemos la clasificacion
# subimos numero de interacciones, de 20 a 600
modelo.NS.H2O <- h2o.deeplearning(x = 2:785, training_frame = training.H2O, 
                                  activation = 'Tanh',  epochs = 600,
                                  hidden = c(400, 200, 2, 200, 400),
                                  autoencoder = T)

# extraer las caracteristicas intermedias del modelo, una capa, en este caso la capa 3
# la capa 3 es el cuello de botella, le definimos solo 2 neuronas
caracteristicas.intermedias <- h2o.deepfeatures(modelo.NS.H2O, training.H2O,
                                                layer = 3)

data.grafico <- as.data.frame(caracteristicas.intermedias)
data.grafico$label <- as.character(as.vector(training.H2O[,1]))

qplot(DF.L3.C1, DF.L3.C2, data = data.grafico, color = label)

h2o.shutdown(prompt = F)
