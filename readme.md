- [Setup](#setup)
- [Imagenes](#imagenes)
- [OpenCV](#opencv)
  * [Algoritmos](#algoritmos)
    + [Viola-Jones](#viola-jones)
    + [Haar-like Features](#haar-like-features)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


# Setup

Add project
```
python3 -m venv entorno
source entorno/bin/activate
pip freeze >> requirements.txt
```

```sh
pip install opencv-python
```

# Imagenes
Las imagenes **RGB** se componen de una matriz de 3 canales (red, blue & green)<br />
<img src="images/1.png" width="50%"/>
<img src="images/2.png" width="40%"/><br />
Convertir una imagen a **blanco y negro** hace que funcione de manera binaria y mucho mas simple para la maquina<br />

## Integral Image
Es muy costoso hacer una sumatoria de cuadrados para cada uno, por eso utilizamos una imagen integral<br />
Genera matriz sumando los valores hasta la izquierda y hasta arriba<br />
<img src="images/9.png"/><br />
De esta manera solo tenemos que realizar la ecuacion con estos 4 valores, por mas que el cuadro contenga miles de pixels<br />
<img src="images/10.png" width="40%"/>
<img src="images/11.png" width="40%"/><br />
<img src="images/12.png" width="40%"/>
<img src="images/13.png" width="40%"/><br />
<img src="images/14.png"/><br />

# OpenCV

## Algoritmos

### Viola-Jones
<img src="images/3.png"/><br />
Va desde arriba a la derecha hasta abajo a la izquierda, buscando ojos, nariz, boca. Hasta que detecta el rostro (encontrando todo)<br />
Este algoritmo funciona solo para rostros frontales<br />

### Haar-like Features
<img src="images/4.png"/><br />
Detecta las lineas mas oscuras, como en la boca (lineal)<br />
Las pestañas, detecta el cambio de color, la division<br />
<img src="images/6.png" width="40%"/>
<img src="images/5.png" width="40%"/><br />
Deteccion de los vaores entre 0 y 1 (escala de grises)<br />
<img src="images/7.png"/><br />
Para calcular que representa el blanco y el negro se calcula la media de los valores<br />
<img src="images/8.png"/><br />