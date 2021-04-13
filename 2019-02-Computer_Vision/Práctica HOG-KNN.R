
# Clasificación HOG - KNN (K vecino más cercano)

train <- read.csv("train.csv", header = T)

data <- train[,-1]
etiquetas <- train[,1] + 1

data <- as.matrix(data)

library(OpenImageR)

hog <- HOG_apply(data, cells = 6, orientations = 9, rows = 28, columns = 28, 
                 threads = 6)
dim(hog)

library(KernelKnn)

modelo.HOG <- KernelKnnCV(hog, etiquetas, k = 20, folds = 4, method = 'braycurtis',
                          weights_function = 'biweight_tricube_MULT', regression = F,
                          threads = 6, Levels = sort(unique(etiquetas)))

precision <- function(etiquetas, predicciones) {
  CM <- table(etiquetas, max.col(predicciones, ties.method = 'random'))
  precision <- sum(diag(CM))/sum(CM)
}

precision.Modelo <- unlist(lapply(1:length(modelo.HOG$preds),
                                  function(x) precision(etiquetas[modelo.HOG$folds[[x]]],
                                                        modelo.HOG$preds[[x]])))

precision.Modelo
mean(precision.Modelo)

# Accuracy / Precisión : 0.9842380952


# Modificar el valor de k ----------------------------------------------

modelo.HOG <- KernelKnnCV(hog, etiquetas, k = 30, folds = 4, method = 'braycurtis',
                          weights_function = 'biweight_tricube_MULT', regression = F,
                          threads = 6, Levels = sort(unique(etiquetas)))

precision.Modelo <- unlist(lapply(1:length(modelo.HOG$preds),
                                  function(x) precision(etiquetas[modelo.HOG$folds[[x]]],
                                                        modelo.HOG$preds[[x]])))

precision.Modelo
mean(precision.Modelo)

# Accuracy / Precisión : 0.9841429

# Reducir el valor de k -----------------------------------------------------

modelo.HOG <- KernelKnnCV(hog, etiquetas, k = 10, folds = 4, method = 'braycurtis',
                          weights_function = 'biweight_tricube_MULT', regression = F,
                          threads = 6, Levels = sort(unique(etiquetas)))

precision.Modelo <- unlist(lapply(1:length(modelo.HOG$preds),
                                  function(x) precision(etiquetas[modelo.HOG$folds[[x]]],
                                                        modelo.HOG$preds[[x]])))

precision.Modelo
mean(precision.Modelo)

# Accuracy / Precisión : 0.9838333


# Ejercicio libre: ----------------------------------------------------

modelo.HOG <- KernelKnnCV(hog, etiquetas, k = 20, folds = 4, method = 'braycurtis',
                          weights_function = 'biweight_tricube_MULT', regression = F,
                          threads = 6, Levels = sort(unique(etiquetas)))


# Modificar orientaciones en HOG ---------------------------------------

hog <- HOG_apply(data, cells = 6, orientations = 15, rows = 28, columns = 28, 
                 threads = 6)

modelo.HOG <- KernelKnnCV(hog, etiquetas, k = 20, folds = 4, method = 'braycurtis',
                          weights_function = 'biweight_tricube_MULT', regression = F,
                          threads = 6, Levels = sort(unique(etiquetas)))

precision.Modelo <- unlist(lapply(1:length(modelo.HOG$preds),
                                  function(x) precision(etiquetas[modelo.HOG$folds[[x]]],
                                                        modelo.HOG$preds[[x]])))

precision.Modelo
mean(precision.Modelo)

# Accuracy / Precisión : 0.9851905


