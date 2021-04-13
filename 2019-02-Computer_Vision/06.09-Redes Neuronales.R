
# Caracterizacion Redes Neuronales
# Remplicamos codigo anterior
library(caret)

train <- read.csv("D:\\Cursos\\2017-Udemy\\2019-02-Computer_Vision\\datos\\5\\train.csv", header = T)

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

# Entrenar redes neuronales en base a varios metodos
library(neuralnet)

# los valores de 0 a 9 tenemos que convertirlos para que cada uno sea un nodo
# (los valores de labes) y en ese caso en los nodos que sean correctos tendremos un 1 y en los que no 0
nomColumnas <- names(training)

# Todas las columnas exepto label
predictoresString <- paste(nomColumnas[!nomColumnas %in% "label"], 
                           collapse = " + ")
# numeros del 0 al 9
numeros <- levels(training$label)

# Agregamos columnas lbl_0 al 9 y ahi van a ir los 0 y 1
for(i in numeros){
  training[paste("lbl", i, sep = "_")] <- ifelse(training$label == i, 1, 0)
}
# Traigo unicamente los lbl
nomColumnas <- names(training)
resultadosString <- paste(nomColumnas[substr(nomColumnas,1,4) %in% "lbl_"], 
                          collapse = " + ")

# ~ para separar los datos de la formula
formula <- as.formula(paste(resultadosString, " ~ ", predictoresString))

# hidden -> un nivel de 35 y otro de 10
# step = 1000 tenemos 33604 observaciones, queremos que de una interaccion baya de 1000 a 1000
?neuralnet
modelo.RedesNeuronales <- neuralnet(formula = formula, data = training,
                                    hidden = c(35,10), linear.output = F,
                                    threshold = 35, stepmax = 1e04,
                                    err.fct = "ce", lifesign = "full",
                                    lifesign.step = 100)

#compute -> calcula del fichero el modelo, sacamos una listado
prediccion.RedesNeuronales <- compute(modelo.RedesNeuronales, testing[,-1])

#lo tenemos en net.result del 1 al 10 que seria del 0 al 9, neuranlnet trabaja del 1 al 10 no del 0 al 9
#el 1 seria el 0, para eso le restamos 1
prediccion <- max.col(prediccion.RedesNeuronales$net.result[,1:10])
prediccion <- prediccion - 1
prediccion.RedesNeuronales <- prediccion

confusionMatrix(prediccion.RedesNeuronales, testing$label)

# Accuracy/PrecisiC3n = 0.8975703

