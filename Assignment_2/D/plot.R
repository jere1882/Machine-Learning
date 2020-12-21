#!/usr/bin/env Rscript

# Leemos todas las tablitas


c1 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.1',sep='\t', header=FALSE)
d1 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.0.1',sep='\t', header=FALSE)
d2 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.0.01',sep='\t', header=FALSE)
d3 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.0.001',sep='\t', header=FALSE)
d4 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.0.0001',sep='\t', header=FALSE)
d5 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.0.00001',sep='\t', header=FALSE)
d6 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.0.000001',sep='\t', header=FALSE)
d7 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.0.0000001',sep='\t', header=FALSE)
d8 <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 2/D/ploteos/ssp.0.00000001',sep='\t', header=FALSE)

names(c1) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")
names(d1) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")
names(d2) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")
names(d3) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")
names(d4) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")
names(d5) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")
names(d6) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")
names(d7) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")
names(d8) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest","WD")

epocas <- 1:500
# Calculamos los valores maximos y minimos de y en el grafico

#############################################################################
minY <- min(c1$MSETr,c1$MSETest)
maxY <- max(c1$MSETr,c1$MSETest)


#Ploteamos

pdf("Gamma = 1.pdf")


plot(epocas, c1$MSETr, col="blue", main = "Gamma = 1" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, c1$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

#############################################################################

minY <- min(d1$MSETr,d1$MSETest)
maxY <- max(d1$MSETr,d1$MSETest)


#Ploteamos

pdf("Gamma = 0.1.pdf")


plot(epocas, d1$MSETr, col="blue", main = "Gamma = 0.1" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d1$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################


minY <- min(d2$MSETr,d2$MSETest)
maxY <- max(d2$MSETr,d2$MSETest)


#Ploteamos

pdf("Gamma = 0.01.pdf")


plot(epocas, d2$MSETr, col="blue", main = "Gamma = 0.01" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d2$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################


minY <- min(d3$MSETr,d3$MSETest)
maxY <- max(d3$MSETr,d3$MSETest)


#Ploteamos

pdf("Gamma = 0.001.pdf")


plot(epocas, d3$MSETr, col="blue", main = "Gamma = 0.001" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d3$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################
minY <- min(d4$MSETr,d4$MSETest)
maxY <- max(d4$MSETr,d4$MSETest)


#Ploteamos

pdf("Gamma = 0.0001.pdf")


plot(epocas, d4$MSETr, col="blue", main = "Gamma = 0.0001" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d4$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################
minY <- min(d5$MSETr,d5$MSETest)
maxY <- max(d5$MSETr,d5$MSETest)


#Ploteamos

pdf("Gamma = 0.00001.pdf")


plot(epocas, d5$MSETr, col="blue", main = "Gamma = 0.00001" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d5$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################


minY <- min(d6$MSETr,d6$MSETest)
maxY <- max(d6$MSETr,d6$MSETest)


#Ploteamos

pdf("Gamma = 0.000001.pdf")


plot(epocas, d6$MSETr, col="blue", main = "Gamma = 0.000001" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d6$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################


minY <- min(d7$MSETr,d7$MSETest)
maxY <- max(d7$MSETr,d7$MSETest)


#Ploteamos

pdf("Gamma = 0.0000001.pdf")


plot(epocas, d7$MSETr, col="blue", main = "Gamma = 0.0000001" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d7$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################

minY <- min(d8$MSETr,d8$MSETest)
maxY <- max(d8$MSETr,d8$MSETest)


#Ploteamos

pdf("Gamma = 0.00000001.pdf")


plot(epocas, d8$MSETr, col="blue", main = "Gamma = 0.00000001" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d8$MSETest, col="red", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error", "Test error")
       , col=c("blue", "red")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################

minY <- min(d5$WD,d4$WD,d6$WD)
maxY <- max(d5$WD,d4$WD,d6$WD)


#Ploteamos

pdf("Comparacion WD")


plot(epocas, d4$WD, col="blue", main = "Comparacion WD" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d5$WD, col="red", lwd = 1, lty=1)
lines(epocas, d6$WD, col="green", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("gamma = 0.0001", "gamma = 0.00001", "gamma = 0.000001")
       , col=c("blue", "red","green")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

###########################################################################

minY <- min(d5$MSETr,d5$MSETest,
            d4$MSETr,d4$MSETest,
            d6$MSETr,d6$MSETest)
            
maxY <- max(d5$MSETr,d5$MSETest,
            d4$MSETr,d4$MSETest,
            d6$MSETr,d6$MSETest)

#Ploteamos

pdf("Comparación MSE")


plot(epocas, d5$MSETr, col="red", main = "MSE Comparación" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, d5$MSETest, col="orange", lwd = 2, lty=1)
lines(epocas, d6$MSETr, col="black", lwd = 1, lty=1)
lines(epocas, d6$MSETest, col="blue", lwd = 2, lty=1)


legend(  x="topright" 
       , legend=c("Training error gamma=0.00001", "Test error gamma=0.00001", "Training error gamma=0.000001", "Test error gamma=0.000001")
       , col=c("red","orange","black","blue")
       , lty=c(1,1,1,1)
       , lwd=3
       , pch=16 
)





