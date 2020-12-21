#!/usr/bin/env Rscript

# Leemos todas las tablitas


c1 <- read.csv('/home/jere/Escritorio/C/ploteos/ikeda.95',sep='\t', header=FALSE)
c2 <- read.csv('/home/jere/Escritorio/C/ploteos/ikeda.75',sep='\t', header=FALSE)
c3 <- read.csv('/home/jere/Escritorio/C/ploteos/ikeda.50',sep='\t', header=FALSE)

names(c1) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
names(c2) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")
names(c3) <- c("Sum","MSETr","MSEV","MSETest","ERRTr","ERRV","ERRTest")



epocas <- 1:100
# Calculamos los valores maximos y minimos de y en el grafico

minY <- c(0)
maxY <- max(c1$MSETr,c1$MSEV,c1$MSETest)


#Ploteamos

pdf("Curva95.pdf")


plot(epocas, c1$MSETr, col="blue", main = "95% datos test" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, c1$MSEV, col="red", lwd = 1, lty=1)
lines(epocas, c1$MSETest, col="green", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error","Validacion error", "Test error")
       , col=c("blue", "red", "green")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

minY <- c(0)
maxY <- max(c2$MSETr,c2$MSEV,c2$MSETest)




pdf("Curva75.pdf")


plot(epocas, c2$MSETr, col="blue", main = "75% datos test" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, c2$MSEV, col="red", lwd = 1, lty=1)
lines(epocas, c2$MSETest, col="green", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error","Validacion error", "Test error")
       , col=c("blue", "red", "green")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)

minY <- c(0)
maxY <- max(c3$MSETr,c3$MSEV,c3$MSETest)



pdf("Curva50.pdf")


plot(epocas, c3$MSETr, col="blue", main = "50% datos test" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Cantidad de épocas de entrenamiento / 200"
    , ylab = "MSE"
    , lwd = 1
    )

lines(epocas, c3$MSEV, col="red", lwd = 1, lty=1)
lines(epocas, c3$MSETest, col="green", lwd = 1, lty=1)


legend(  x="topright" 
       , legend=c("Training error","Validacion error", "Test error")
       , col=c("blue", "red", "green")
       , lty=c(1,1,1)
       , lwd=3
       , pch=16 
)





