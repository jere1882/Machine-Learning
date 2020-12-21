#!/usr/bin/env Rscript

# Leemos todas las tablitas


c1 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.001.0.9',sep='\t', header=FALSE)
#c2 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.01.0',sep=' ', header=FALSE)
#c3 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.001.0',sep=' ', header=FALSE)
#c4 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.1.0.5',sep=' ', header=FALSE)
#c5 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.01.0.5',sep=' ', header=FALSE)
#c6 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.001.0.5',sep=' ', header=FALSE)
#c7 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.1.0.9',sep=' ', header=FALSE)
#c8 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.01.0.9',sep=' ', header=FALSE)
#c9 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/A/ploteos/curva.0.001.0.9',sep=' ', header=FALSE)
 
names(c1) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
#colnames(c2) <-("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
#colnames(c3) <-("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
#colnames(c4) <-("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
#colnames(c5) <-("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
#colnames(c6) <-("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
#colnames(c7) <-("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
#colnames(c8) <-("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
#colnames(c9) <-("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")

epocas <- 1:100
# Calculamos los valores maximos y minimos de y en el grafico

minY <- c(0)
maxY <- c(0.35)

#Ploteamos

pdf("Curva1.pdf")


plot(epocas, c1$ERRTr, col="blue", main = "Evolución de los errores con LR=0.001 M=0.9" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 400"
    , ylab = "Error porcentual"
    , lwd = 1
    )

lines(epocas, c1$ERRV, col="red", lwd = 1, lty=1)
lines(epocas, c1$ERRTest, col="green", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error","Validacion error", "Test error")
       , col=c("blue", "red", "green")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)





