#!/usr/bin/env Rscript

# Leemos todas las tablitas

espiral2  <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/B/ploteos/espiral.2',sep='\t')
espiral5  <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/B/ploteos/espiral.5',sep='\t')
espiral10 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/B/ploteos/espiral.10',sep='\t')
espiral20 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/B/ploteos/espiral.20',sep='\t')
espiral40 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/B/ploteos/espiral.40',sep='\t')

q <- espiral2
pdf("2.pdf")


plot(q[,1], q[,2],col=q[,3]+3, main = "Predicción con 2 neuronas en capa intermedia"   , xlab = "x"
    , ylab = "y")

q <- espiral5
pdf("5.pdf")


plot(q[,1], q[,2],col=q[,3]+3, main = "Predicción con 5 neuronas en capa intermedia"   , xlab = "x"
    , ylab = "y")

q <- espiral10
pdf("10.pdf")


plot(q[,1], q[,2],col=q[,3]+3, main = "Predicción con 10 neuronas en capa intermedia"   , xlab = "x"
    , ylab = "y")

q <- espiral20
pdf("20.pdf")


plot(q[,1], q[,2],col=q[,3]+3, main = "Predicción con 20 neuronas en capa intermedia"   , xlab = "x"
    , ylab = "y")

q <- espiral40
pdf("40.pdf")


plot(q[,1], q[,2],col=q[,3]+3, main = "Predicción con 40 neuronas en capa intermedia"   , xlab = "x"
    , ylab = "y")

