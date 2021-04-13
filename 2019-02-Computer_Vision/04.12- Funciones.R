
# Funciones
# Concepto caja negra:   INPUT -> [CAJA NEGRA] -> OUTPUT

valores <- c(2, 3, 5)
sd( x = valores, na.rm = FALSE)
sd(valores, F)
sd(valores)
args(sd)
sd(na.rm = FALSE, x = valores)
sd(FALSE, valores)

valores2 <- c(2, 3, 5, NA)
sd(valores2)
sd(valores2, na.rm = TRUE)

sd(na.rm = FALSE)

# Creación de Funciones

mi_suma <- function (a, b) {
  c <- a + b
  return(c)
}

mi_suma(1,2)
mi_suma(1)

args(mi_suma)

mi_suma <- function (a, b = 0) {
  c <- a + b
  return(c)
}

mi_suma(1)
args(mi_suma)

mi_resta <- function (a, b = 0){
  c <- a - b
  return(c)
}

mi_resta(5, 3)
mi_resta(5, -3)
mi_resta(b = 5, a = -3)
mi_resta(b = 5)
args(mi_resta)


mi_suma2 <- function( a, b = 0){
  c <- a + b + numero
  return(c)
}

mi_suma2(5, 2)
numero <- 23
mi_suma2(5, 2)

mi_suma3 <- function( a, b = 0){
  numero <- a * 2
  c <- a + b + numero
  return(c)
}

numero <- 23
mi_suma2(5, 2)
mi_suma3(5, 2)
