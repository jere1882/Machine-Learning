#!/usr/bin/env Rscript

# Leemos todas las tablitas

espiral150 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 4/espiral150/espiral150.prediction',sep='\t')
espiral600 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 4/espiral600/espiral600.prediction',sep='\t')
espiral3000 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 4/espiral3000/espiral3000.prediction',sep='\t')

q <- espiral150
pdf("Espirales con n=150")


plot(q[,1], q[,2],col=q[,3]+3, main = "n=150"   , xlab = "x"
    , ylab = "y")

q <- espiral600
pdf("Espirales con n=600")


plot(q[,1], q[,2],col=q[,3]+3, main = "n=600"   , xlab = "x"
    , ylab = "y")


q <- espiral3000
pdf("Espirales con n=3000")


plot(q[,1], q[,2],col=q[,3]+3, main = "n=3000"   , xlab = "x"
    , ylab = "y")


