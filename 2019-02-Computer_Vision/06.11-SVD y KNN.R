
# Clasificación K Vecinos más Cercanos (K nearest neighbors - KNN)

train <- read.csv("J:\\Cursos\\2017-Udemy\\2019-02-Computer_Vision\\datos\\5\\train.csv", header = T)

data <- train[,-1]
etiquetas <- train[,1] + 1


library(irlba)

svd <- irlba(as.matrix(data), nv = 40, nu = 40)

#Reducimos dimensionalidad de los vectores
train.postsvd <- as.matrix(data) %*% svd$v
dim(train.postsvd)

library(KernelKnn)

#braycurtis -> calcular distancia minima
#threads -> numero de hilos para que sea mas rapido
#Levels -> numero de niveles, en este caso de 0 a 9
modelo.KNN <- KernelKnnCV(as.matrix(train.postsvd), etiquetas,
                          k = 8, folds = 4, method = 'braycurtis',
                          weights_function = 'biweight_tricube_MULT',
                          regression = F, threads = 6,
                          Levels = sort(unique(etiquetas)))

precision <- function(etiquetas, predicciones) {
  CM <- table(etiquetas, max.col(predicciones, ties.method = 'random'))
  precision <- sum(diag(CM))/sum(CM)
}

#modelo.KNN.preds -> 10 columnas con la probabilidad de que sea cada numero
#modelo.KNN$preds[[1]]
#lapply -> aplique una funcion a lo largo de toda la lista
precision.Modelo <- unlist(lapply(1:length(modelo.KNN$preds),
                                  function (x) precision(etiquetas[modelo.KNN$folds[[x]]],
                                                         modelo.KNN$preds[[x]])))

precision.Modelo
mean(precision.Modelo)

#Accuracy/Precisión: 0.9751904762