library(caret)

install.packages("caret")
install.packages("RColorBrewer")
install.packages("e1071")
install.packages("irlba")
install.packages("KernelKnn")
install.packages("OpenImageR")
install.packages("randomForest")
install.packages("neuralnet")
install.packages("h2o")
install.packages("tensorflow")

??tensorflow
library("tensorflow")

install_tensorflow(method = c("auto", "virtualenv", "conda", "system"),
                   conda = "auto", version = "default", envname = "r-tensorflow",
                   extra_packages = c("keras", "tensorflow-hub"),
                   restart_session = TRUE)
