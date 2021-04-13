
# Loop con comando FOR
# Inicialización
v <- rnorm(30)
elementos <- 10

v2 <- 0

# Loop - Bucle
for(i in 1:elementos){
  v2[i] <- v[1] * v[1]
  cat("i: ", i, " ", v[i], " ^ 2 = ", v2[i], "\n")
}


# Bucles anidados - nested loop
# Inicialización
matriz <- matrix(0, nrow = 30, ncol = 30)

# Bucle
for (i in 1:dim(matriz)[1]){
  for (j in 1:dim(matriz)[2]){
    matriz[i,j] <- i * j
    cat (i, " * ", j, " = ", matriz[i,j], "\n")
  }
}

matriz[1:10, 1:10]



# While Loop - Bucle While
# Inicialización
frase <- "Tú también te convertirás en un Héroe del Dato. Si haces mis cursos, será más rápido."

i <- 0
letra <- ""

while (letra != ','){
  i <- i + 1
  letra <- substr(frase, i, i)
  cat(i, " ", letra, "\n")
}



# Repeat Loop - Bucle con Repetición


frase <- "Tú también te convertirás en un Héroe del Dato. Si haces mis cursos, será más rápido."

i <- 0
letra <- ""

repeat {
  i <- i + 1
  letra <- substr(frase, i, i)
  cat(i, " ", letra, "\n")
  if (letra == ','){
    break
  }
}


# Breaks en un For

# Inicialización
matriz <- matrix(0, nrow = 30, ncol = 30)

# Bucle
for (i in 1:dim(matriz)[1]){
  for (j in 1:dim(matriz)[2]){
    if ( i == j){
      break
    } else {
      matriz[i,j] <- i * j
      cat (i, " * ", j, " = ", matriz[i,j], "\n")
    }
  }
}

matriz[1:10, 1:10]


# Comando Next - en bucle while

frase <- "Tú también te convertirás en un Héroe del Dato. Si haces mis cursos, será más rápido."

i <- 0
letra <- ""

while (letra != ','){
  i <- i + 1
  letra <- substr(frase, i, i)
  if (letra == 'a'){
    next
  }
  cat(i, " ", letra, "\n")
}


# Comando Next - en bucle for

# Inicialización
matriz <- matrix(0, nrow = 30, ncol = 30)

# Bucle
for (i in 1:dim(matriz)[1]){
  for (j in 1:dim(matriz)[2]){
    if ( i == j){
      next
    } else {
      matriz[i,j] <- i * j
      cat (i, " * ", j, " = ", matriz[i,j], "\n")
    }
  }
}

matriz[1:10, 1:10]



# Cuando usar o no bucles

v1 <- seq(1,1000000)
v2 <- seq(2000000,1000001)

vt <- 0

pt <- proc.time()
for( i in 1:1000000){
  vt[i] <- v1[i] + v2[i]
}
proc.time() - pt

pt <- proc.time()
vt <- v1 + v2
proc.time() - pt
