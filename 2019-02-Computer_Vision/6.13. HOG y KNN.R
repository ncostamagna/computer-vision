install.packages(c("caret", "recipes", "klaR", "ipred"))
install.packages(c("OpenImageR", "KernelKnn"))
# Clasificación HOG - KNN (K vecino mas cercano)
library(recipes)
library(caret)
library(e1071)

train <- read.csv("D:\\Cursos\\2017-Udemy\\2019-02-Computer_Vision\\datos\\5\\train.csv", header = T)

data <- train[,-1]
etiquetas <- train[,1] + 1

data <- as.matrix(data)

library(OpenImageR)

#Disminuimos una 3ra parte de los datos
hog <- HOG_apply(data, cells = 6, orientations = 9, rows = 28, columns = 28, 
                 threads = 6)
dim(hog)

library(KernelKnn)

modelo.HOG <- KernelKnnCV(hog, etiquetas, k = 20, folds = 4, method = 'braycurtis',
                          weights_function = 'biweight_tricube_MULT', regression = F,
                          threads = 6, Levels = sort(unique(etiquetas)))

#saber cuantos aciertos hay
precision <- function(etiquetas, predicciones) {
  CM <- table(etiquetas, max.col(predicciones, ties.method = 'random'))
  precision <- sum(diag(CM))/sum(CM)
}
# >>> Anotaciones Nahuel

  #Tenemos las 10500 etiquetas
  eti <- etiquetas[modelo.HOG$folds[[1]]]
  
  #Probabilidad en cada una de las columnas correspondientes
  predic <- modelo.HOG$preds[[1]]
  max.col(predic, ties.method = 'random')
  
  #confusion matrix
  CM <- table(eti, max.col(predic, ties.method = 'random'))
  
  diag(CM)
  sum(diag(CM))
  sum(CM)
  sum(diag(CM))/sum(CM)
# <<< Acotaciones Nahuel

precision.Modelo <- unlist(lapply(1:length(modelo.HOG$preds),
                                  function(x) precision(etiquetas[modelo.HOG$folds[[x]]],
                                                        modelo.HOG$preds[[x]])))

precision.Modelo
mean(precision.Modelo)

# Accuracy / Precisión : 0.9842380952
