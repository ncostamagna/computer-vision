library(datasets)

#histograma
hist(airquality$Ozone)

#scatterplot
with(airquality, plot(Wind, Ozone))

#boxplot
airquality <- transform(airquality, Month = factor(Month)) 
boxplot(Ozone ~ Month, airquality, xlab = "Mes", ylab = "Ozono (ppb)")

# Parámetros importantes:
# -pch: el símbolo del punto (por defecto un círculo)
# -lty: el tipo de línea (por defecto sólida): pueden ser rallitas, puntos...
# -lwd: l grosor de la línea
# -col: el color
colors()
# -xlab: el texto del eje x
# -ylab: el texto del eje y

# Principales Funciones
# -plot: Dibuja un scatterplot o de otro tipo, dependiendo de los datos
# -lines: Añade una linea al plot
# -points: Añade puntos al plot
# -text: Añade texto al plot en las coordenadas especificadas
# -title: Añade anotaciones a los ejes, título, subtítulo, o fuera del margen
# -mtext: Añade texto a los márgenes
# -axis: añade nuevos ejes


# Ejemplo con varios parámetros
with(airquality, plot(Wind, Ozone, main = "Ozono y Viento en New York", type = "n"))
with(subset(airquality, Month == 5), points(Wind, Ozone, col = "blue"))
with(subset(airquality, Month != 5), points(Wind, Ozone, col = "red")) 
legend("topright", pch = 1, col = c("blue", "red"), legend = c("Mayo", "Otros Meses"))

# Línea de Regresión
with(airquality, plot(Wind, Ozone, main = "Ozono y Viento en New York", pch = 20))
modelo <- lm(Ozone ~ Wind, airquality) 
abline(modelo, lwd = 2)

# Múltiples plots
par(mfrow = c(1, 3)) 
with(airquality, {
  plot(Wind, Ozone, main = "Ozono y Viento")
  plot(Solar.R, Ozone, main = "Ozono y Radiación Solar") 
  plot(Temp, Ozone, main = "Ozone y Temperatura") 
  mtext("Ozono y Tiempo Atmosférico en New York", outer = TRUE)
})


