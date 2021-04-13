
#Un vistazo por los datos MNIST

train <- read.csv("J:\\Cursos\\2017-Udemy\\2019-02-Computer_Vision\\datos\\5\\train.csv", header = TRUE)

train

unique(train$label)
names(train)
dim(train)

#Convertimos a matriz
train <- as.matrix(train)

#Paleta de colores en negro y blanco
colors <- c('white', 'black')
cus_col <- colorRampPalette(colors = colors)

cus_col

#mfrow -> division de los plot
#pty -> small
#mar -> pintar los margenes
#xaxt, yaxt -> en n, no eje de la x, lo mismo para la y
par(mfrow = c(4,3), pty = 's', mar = c(1,1,1,1), xaxt = 'n', yaxt = 'n')

#10 columnas de 28*28 que tiene la matriz (imagenes de 28x28)
all_img <- array(dim = c(10, 28*28))
for (di in 0:9) {
  print(di)
  #pintamos matriz
  #apply -> funcion recursiva que tomara todas las columnas de train[,-1]
  #         sea igual al valor df,
  #-1 -> resto de valores en la primera columna
  all_img[di+1,] <- apply(train[train[,1] == di, -1], 2, sum)
  
  #Hacemos una media de los valores de cada px, hace una media y la
  #distribuye en una tonalidad de grises
  all_img[di+1,] <- all_img[di+1,] / max(all_img[di+1,])*255
  
  
  z <- array(all_img[di+1,], dim = c(28,28))
  z <- z[,28:1]
  image(1:28, 1:28, z, main = di, col = cus_col(256))
}

pdf('train_letters.pdf')
par(mfrow = c (4,4), pty = 's', mar = c(3,3,3,3), xaxt = 'n', yaxt = 'n')

#quiero todo menos la primera columna que tiene el label
for (i in 1:nrow(train)) {
  
    z <- array(train[i,-1], dim = c(28,28))
    #vertical y no horizontal, damos la vuelta
    z <- z[,28:1]
    #1:28, 1:28 tama??o
    #z objeto imagen
    #main-> label
    z
    image(1:28, 1:28, z, main = train[i,1], col = cus_col(255))
    ?image
    print(i)
}


z <- array(train[10,-1], dim = c(28,28))
z
z <- z[,28:1]
View(z)
#Label
train[3,1]
image(1:28, 1:28, z, main = train[10,1], col = cus_col(255))

train[1,-1]

dev.off()


train <- read.csv("train.csv", header = TRUE)

table(train$label)

#Vemos varios 9 escritos
numero <- 7

train_numero <- train[train$label == numero,]

train_numerom <- as.matrix(train_numero)
par(mfrow = c (3,3), pty = 's', mar = c(3,3,3,3), xaxt = 'n', yaxt = 'n')
for(i in 10:18){
  z <- array(train_numerom[i,-1], dim = c(28,28))
  z <- z[,28:1]
  image(1:28, 1:28, z, main = train_numerom[i,1], col = cus_col(256))
}

test <- read.csv("test.csv", header = TRUE)

dim(train)
dim(test)

names(test)
names(train)


test_m <- as.matrix(test)
par(mfrow = c (3,3), pty = 's', mar = c(3,3,3,3), xaxt = 'n', yaxt = 'n')
for(i in 10:18){
  z <- array(test_m[i,-1], dim = c(28,28))
  z <- z[,28:1]
  image(1:28, 1:28, z, col = cus_col(256))
}

