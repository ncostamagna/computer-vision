
# Clasificacion mediante metodo Softmax regresion con tensorflow
# install.packages('tensorflow')

library(tensorflow)

# ---> Solo uso esto para bajar los archivos 

url1 <- 'http://yann.lecun.com/exdb/mnist/train-images-idx3-ubyte.gz'
url2 <- 'http://yann.lecun.com/exdb/mnist/train-labels-idx1-ubyte.gz'
url3 <- 'http://yann.lecun.com/exdb/mnist/t10k-images-idx3-ubyte.gz'
url4 <- 'http://yann.lecun.com/exdb/mnist/t10k-labels-idx1-ubyte.gz'

destino1 <- 'train-images-idx3-ubyte.gz'
destino2 <- 'train-labels-idx1-ubyte.gz'
destino3 <- 't10k-images-idx3-ubyte.gz'
destino4 <- 't10k-labels-idx1-ubyte.gz'

download.file(url1, destino1, method = 'auto')
download.file(url2, destino2, method = 'auto')
download.file(url3, destino3, method = 'auto')
download.file(url4, destino4, method = 'auto')
# <--- Solo uso esto para bajar los archivos 

# Crear el modelo: y = Softmax(W.x + b)
# placeholder -> espacio que tenemos reservado para guardar diversos datos
# shape -> la dimension no la sabemos (null), sabemos la cantidad de numeros (784)
x <- tf$placeholder(tf$float32, shape(NULL, 784L))
# 784 numeros por 10 clases
W <- tf$Variable(tf$zeros(shape(784L, 10L))) # va a variar, inicializamos en cero
b <- tf$Variable(tf$zeros(shape(10L)))

# nn -> neural net soport
y <- tf$nn$softmax(tf$matmul(x,W) + b)

# Definir lo que entendemos como funcion de perdida, y vamos a tratar
# de optimizarla

y_ <- tf$placeholder(tf$float32, shape(NULL, 10L)) # vamos a poner aqui el resultado

# calculamos entropia cruzada, funcion de perdida
cross_entropy <- tf$reduce_mean(-tf$reduce_sum(y_ * log(y), reduction_indices = 1L))

# Optimizador
optimizer <- tf$train$GradientDescentOptimizer(0.5) # gradiante minimo
train_step <- optimizer$minimize(cross_entropy)

# Inicializar TF y variables
sess <- tf$Session()
sess$run(tf$global_variables_initializer()) # Inicializa todas las variables a nuestro local, nuestra sesion

# Cargar datasets de MNIST, cargamos unos dataset que proporciona tf
dataset <- tf$contrib$learn$datasets
# extraigo los dataser que baje
mnist <- dataset$mnist$read_data_sets("computer_vision_01/MNIST-data", one_hot = T)

#Hacemos el entrenamiento, bucle que va de 1 a 1000
for(i in 1:1000){
  batches <- mnist$train$next_batch(100L) # 100 observaciones aleatoreas de 50.000 que tiene mnist
  batches_xs <- batches[[1]] # agarro la primera parte
  batches_ys <- batches[[2]]
  sess$run(train_step,
           feed_dict = dict( x = batches_xs, y_ = batches_ys)) # le pasamos los placeholder, tf ira calculandpo los mejores valores
}

# test del modelo
# argmax -> el mayor, que tenga mayor probabilidad, y solo queremos uno (1L)
# y_ -> y verdadera que viene de los datos
correct_prediction <- tf$equal(tf$argmax(y, 1L), tf$argmax(y_, 1L))

# eficiencia
accuary <- tf$reduce_mean(tf$cast(correct_prediction, tf$float32))
# x = mnist$test$images -> imagenes que tenemos de test
sess$run(accuary,
         feed_dict = dict( x = mnist$test$images, y_ = mnist$test$labels))

# 0.921 de eficiencia

