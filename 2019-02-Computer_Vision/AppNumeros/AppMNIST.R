install.packages("caret",
                 repos = "http://cran.r-project.org", 
                 dependencies = c("Depends", "Imports", "Suggests"))


library(shiny)
library(shinydashboard)
library(png)
library(caret)
library(e1071)
library(randomForest)
library(neuralnet)

### Definición de variables globales
lado = 28
grosor = 5
anchura = lado * 10 + 1
altura = lado * 10 + 1

precisionNB = .5347
precisionRF = .9446
precisionSVM <- .9721
precisionNN <- .8976

nombres <- as.vector(unlist(read.csv("nombres.csv")))
nvz.default <- as.vector(unlist(read.csv("nvz.columnas.csv")))

load(file = "modelo.SVM.rda")
load(file = "modelo.PCA.rda")
load(file = "modelo.NaiveBayes.rda")
load(file = "modelo.RandomForest.rda")
load(file = "modelo.RedesNeuronales.rda")

# Funciones

# funcion que dibuja los numeros
procesar_valores <- function(filas, columnas, m){
  
  #browser()
  
  filas <- interpolar_valores(filas, 5)
  columnas <- interpolar_valores(columnas, 5)
  
  filas <- abs(round(filas, 0) - lado*10)
  columnas <- round(columnas, 0)
  
  for(i in 1:length(filas)){
    
    if(!is.na(filas[i])){
      
      if(filas[i] - grosor > 0 & filas[i] + grosor < lado * 10 + 1 & 
         columnas[i] - grosor > 0 & columnas[i] + grosor < lado * 10 + 1){
        
        m[seq(filas[i]-grosor, filas[i]+grosor),
          seq(columnas[i] - grosor, columnas[i] + grosor)] <- 0
        
      } else {
        
        next()
        
      }
      
    }
    
  }
  
  return(m)
  
}

# Interpolar todos los numeros que hay en el medio, mostrar en el dibujo
interpolar_valores <- function(vector, repeticiones = 1){
  
  #browser() -> para hacer debbug
  
  iteracion <- 1
  
  while(iteracion <= repeticiones){
    
    vector_nuevo <- vector[1]
    anterior <- vector[1]
    
    for(i in 2:length(vector)){
      
      if(is.na(vector[i])){
        
        vector_nuevo <- c(vector_nuevo, vector[i])
        anterior <- vector[i]
        
      } else {
        
        if(is.na(anterior)){
          
          vector_nuevo <- c(vector_nuevo, vector[i])
          anterior <- vector[i]
          
        } else {
          
          valor_nuevo <- (vector[i] - anterior)/2 + anterior
          vector_nuevo <- c(vector_nuevo, valor_nuevo, vector[i])
          anterior <- vector[i]
          
        }
        
      }
      
    }
    
    iteracion <- iteracion + 1
    vector <- vector_nuevo
    
  }
  
  return(vector)
  
}


convertir_matriz <- function(matriz) {
  
  imagen <- c()
  
  for(fila in 1:lado){
    
    for(columna in 1:lado){
      
      fila_minima <- (fila - 1) * 10 + 1
      fila_maxima <- fila * 10
      columna_minima <- (columna - 1) * 10 + 1
      columna_maxima <- columna * 10
      
      pixel <- sum(matriz[c(seq(fila_minima, fila_maxima)), c(seq(columna_minima, columna_maxima))])
      pixel <- round(abs(pixel - 100) * 256 / 100, 0)
      
      imagen <- c(imagen, pixel)
    }
    
  }
  
  #browser()
  imagen <- as.data.frame(t(imagen))
  names(imagen) <- nombres
  return(imagen)
  
}

#####################################
###      Dibujar pantalla web     ###
#####################################
ui <- dashboardPage(
  
  dashboardHeader(
    title = "Predicción MNIST",
    titleWidth = 350
  ),
  
  dashboardSidebar(width = 350,
                   fluidRow(
                     column(10, offset = 1,
                            plotOutput("plot", 
                                       width = "90%",
                                       height = "300px",
                                       click = "click",
                                       hover = hoverOpts("hover", delay = 500, 
                                                         delayType = "throttle", 
                                                         nullOutside = T)),
                            actionLink("limpiar", "Limpiar"),
                            hr(),
                            imageOutput("matriz")
                            )
                   )
                   ),
  
  dashboardBody(
    fluidRow(
      
      box(
        title = "Predicciones",
        status = "primary",
        solidHeader = T,
        width = 6,
        collapsible = T,
        fluidRow(
          column(6,
                 valueBoxOutput("prediccionNB", width = 12)),
          column(6,
                 valueBoxOutput("prediccionRF", width = 12))
        ),
        fluidRow(
          column(6,
                 valueBoxOutput("prediccionSVM", width = 12)),
          column(6,
                 valueBoxOutput("prediccionNN", width = 12))
        )
      ),
      box(
        title = "Precisiones",
        status = "warning",
        solidHeader = T,
        width = 6,
        collapsible = T,
        fluidRow(
          column(6,
                 valueBoxOutput("precisionNB", width = 12)),
          column(6,
                 valueBoxOutput("precisionRF", width = 12))
        ),
        fluidRow(
          column(6,
                 valueBoxOutput("precisionSVM", width = 12)),
          column(6,
                 valueBoxOutput("precisionNN", width = 12))
        )
      )
    ),
    fluidRow(
      column(6, offset = 3,
             box(
               title = "Predicciones",
               status = "success",
               solidHeader = T,
               width = 12,
               collapsible = T,
               fluidRow(
                 column(6,
                        valueBoxOutput("prediccionTotal", width = 12)),
                 column(6,
                        valueBoxOutput("precisionTotal", width = 12))
               )
             ))
    )
      
    )
  
)

server <- function(input, output){
  
  #### Definición de Variables y Constantes locales, por usuario
  
  dibujar <- reactiveVal(FALSE)
  valores <- reactiveValues(x = NULL, y = NULL)
  
  m <- matrix(1, nrow = altura, ncol = anchura)
  
  v <- reactiveValues(m = m,
                      imagen_nueva = NULL,
                      prediccionNB = NA,
                      prediccionRF = NA,
                      prediccionSVM = NA,
                      prediccionNN = NA,
                      precision_total = NA)
  
  observeEvent(input$click,
               {
                 #browser()
                 tmp <- dibujar()
                 dibujar(!tmp)
                 if (!dibujar()){
                   valores$x <- c(valores$x, NA)
                   valores$y <- c(valores$y, NA)
                   v$m <- procesar_valores(valores$y, valores$x, v$m)
                   v$imagen_nueva <- convertir_matriz(v$m)
                   
                 }
                 
               })
  
  observeEvent(input$hover,
               {
                 
                 if(dibujar()){
                   valores$x <- c(valores$x, input$hover$x)
                   valores$y <- c(valores$y, input$hover$y)
                 }
                 
               })
  
  output$plot <- renderPlot({
    
    plot(valores$x, valores$y, xlab = "", ylab = "", main = "",
         xlim = c(0, lado*10+1), ylim = c(0, lado*10+1),
         xaxt = "n", yaxt = "n", type = "l", lwd = grosor)
    
  })
  
  output$matriz <- renderImage({
    
    ### IMagen con cuadraditos, tipo cuadriculado
    m <- v$m
    
    m[seq_len(ceiling(altura/10))*10 - 9,] <- 0.75
    m[,seq_len(ceiling(anchura/10))*10 - 9] <- 0.75
    
    matriz <- array(c(m, m, m), dim = c(altura, anchura, 3))
    
    fichero_tmp <- tempfile(fileext = ".png")
    writePNG(matriz, target = fichero_tmp)
    
    imagen <- list(
      src = fichero_tmp,
      contentType = "image/png",
      width = anchura,
      height = altura,
      alt = "Matriz resultante"
    )
    
  })
  
  output$prediccionNB <- renderValueBox({
    
    if(is.null(v$imagen_nueva)){
      
      prediccion <- "NA"
      
    } else {
      
      prediccion <- predict(modelo.NaiveBayes, newdata = v$imagen_nueva)
      prediccion <- as.numeric(as.character(prediccion))
      
    }
    
    v$prediccionNB <- prediccion
    
    valueBox(prediccion, 
             subtitle = "predicción NB",
             icon = icon("tasks", lib = "glyphicon"),
             color = "blue")
    
  })
  
  output$prediccionRF <- renderValueBox({
    
    if(is.null(v$imagen_nueva)){
      
      prediccion <- "NA"
      
    } else {
      
      #browser()
      
      imagen_nueva.postnzv <- v$imagen_nueva[,-nvz.default]
      imagen_nueva.postPCA <- predict(train.preproc, newdata = imagen_nueva.postnzv)
      
      prediccion <- predict(modelo.RandomForest, newdata = imagen_nueva.postPCA)
      prediccion <- as.numeric(as.character(prediccion))
      
    }
    
    v$prediccionRF <- prediccion
    
    valueBox(prediccion, 
             subtitle = "predicción RF",
             icon = icon("tree-conifer", lib = "glyphicon"),
             color = "green")
    
  })
  
  output$prediccionSVM <- renderValueBox({
    
    if(is.null(v$imagen_nueva)){
      
      prediccion <- "NA"
      
    } else {
      
      #browser()
      
      imagen_nueva.postnzv <- v$imagen_nueva[,-nvz.default]
      imagen_nueva.postPCA <- predict(train.preproc, newdata = imagen_nueva.postnzv)
      
      prediccion <- predict(modelo.SVM, newdata = imagen_nueva.postPCA)
      prediccion <- as.numeric(as.character(prediccion))
      
    }
    
    v$prediccionSVM <- prediccion
    
    valueBox(prediccion, 
             subtitle = "predicción SVM",
             icon = icon("resize-small", lib = "glyphicon"),
             color = "orange")
    
  })
  
  output$prediccionNN <- renderValueBox({
    
    if(is.null(v$imagen_nueva)){
      
      prediccion <- "NA"
      
    } else {
      
      #browser()
      
      imagen_nueva.postnzv <- v$imagen_nueva[,-nvz.default]
      imagen_nueva.postPCA <- predict(train.preproc, newdata = imagen_nueva.postnzv)
      
      prediccion <- compute(modelo.RedesNeuronales, imagen_nueva.postPCA)
      prediccion <- max.col(prediccion$net.result)
      prediccion <- as.numeric(as.character(prediccion))
      
    }
    
    v$prediccionNN <- prediccion
    
    valueBox(prediccion, 
             subtitle = "predicción NN",
             icon = icon("random", lib = "glyphicon"),
             color = "purple")
    
  })
  
  output$precisionNB <- renderValueBox({
    
    precision <- paste(round(precisionNB * 100, digits = 1),"%")
    
    valueBox(precision, 
             subtitle = "precisión NB",
             icon = icon("tasks", lib = "glyphicon"),
             color = "blue")
    
  })
  
  output$precisionRF <- renderValueBox({
    
    precision <- paste(round(precisionRF * 100, digits = 1),"%")
    
    valueBox(precision,  
             subtitle = "precisión RF",
             icon = icon("tree-conifer", lib = "glyphicon"),
             color = "green")
    
  })
  
  output$precisionSVM <- renderValueBox({
    
    precision <- paste(round(precisionSVM * 100, digits = 1),"%")
    
    valueBox(precision, 
             subtitle = "precisión SVM",
             icon = icon("resize-small", lib = "glyphicon"),
             color = "orange")
    
  })
  
  output$precisionNN <- renderValueBox({
    
    precision <- paste(round(precisionNN * 100, digits = 1),"%")
    
    valueBox(precision, 
             subtitle = "precisión NN",
             icon = icon("random", lib = "glyphicon"),
             color = "purple")
    
  })
  
  output$prediccionTotal <- renderValueBox({
    
    predicciones <- c(v$prediccionNB, v$prediccionRF, v$prediccionSVM, v$prediccionNN)
    precisiones <- c(precisionNB, precisionRF, precisionSVM, precisionNN)
    resultados <- data.frame(predicciones, precisiones)
    tabla <- aggregate(precisiones ~ predicciones, data = resultados, FUN = sum)
    prediccion_total <- tabla[tabla$precisiones == max(tabla$precisiones),]$predicciones
    v$precision_total <- tabla[tabla$precisiones == max(tabla$precisiones),]$precisiones / sum(tabla$precisiones)
    
    valueBox(prediccion_total, 
             subtitle = "Predicción",
             icon = icon("ok", lib = "glyphicon"),
             color = "red")
    
  })
  
  output$precisionTotal <- renderValueBox({
    
    precision <- paste(round(v$precision_total * 100, digits = 1),"%")
    
    valueBox(precision, 
             subtitle = "Precisión",
             icon = icon("repeat", lib = "glyphicon"),
             color = "red")
    
  })
  
  observeEvent(input$limpiar,
               {
                 
                 v$m <- matrix(1, nrow = altura, ncol = anchura)
                 
                 v$imagen_nueva <- NULL
                 
                 valores$x <- NULL
                 valores$y <- NULL
                 
               })
  
}

# Lanzador
shinyApp(ui, server)