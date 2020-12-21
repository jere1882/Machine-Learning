#!/usr/bin/env Rscript

# Leemos todas las tablitas

datos1 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 8/xor.data.1',sep=',')
datos0 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 8/xor.data.0',sep=',')

minX <- min(datos1$X, datos0$X)
maxX <- max(datos1$X, datos0$X)
minY <- min(datos1$Y, datos0$Y)
maxY <- max(datos1$Y, datos0$Y)

plot(datos0$X, datos0$Y, col="red"
    , xlim = c(minX, maxX), ylim = c(minY, maxY)
    , xlab = "x", ylab = "y"
    , pch = 20, cex = .5
    )

points(datos1$X, datos1$Y, col="blue", pch = 20, cex = .5)

