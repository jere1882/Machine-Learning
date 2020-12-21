#!/usr/bin/env Rscript

# Leemos todas las tablitas

d_bp_m <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 7/d_bp_average_errorm',sep=' ')
d_bp_t <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 7/d_bp_average_errort',sep=' ')
d_ap_m <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 7/d_ap_average_errorm',sep=' ')
d_ap_t <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 7/d_ap_average_errort',sep=' ')
p_bp_m <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 7/p_bp_average_errorm',sep=' ')
p_bp_t <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 7/p_bp_average_errort',sep=' ')
p_ap_m <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 7/p_ap_average_errorm',sep=' ')
p_ap_t <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 7/p_ap_average_errort',sep=' ')


# Calculamos los valores maximos y minimos de y en el grafico

#minY <- min(d_bp_m$d_bp_errorm, d_bp_t$d_bp_errort, p_bp_m$p_bp_errorm, p_bp_t$p_bp_errort)
#maxY <- max(d_bp_m$d_bp_errorm, d_bp_t$d_bp_errort, p_bp_m$p_bp_errorm, p_bp_t$p_bp_errort)


#Ploteamos el before prunning

pdf("ErrBP")


#plot(d_bp_m$n, d_bp_m$d_bp_errorm, col="blue", main = "Error Before Pruning" 
#    , type = "l"
#    , ylim = c(minY, maxY)
#    , xlab = "Número de dimensiones"
#    , ylab = "Error porcentual"
#    , lwd = 1
#    )

#lines(d_bp_m$n, d_bp_t$d_bp_errort, col="blue", lwd = 1, lty=2)
#lines(d_bp_m$n, p_bp_m$p_bp_errorm, col="red", lwd = 1)
#lines(d_bp_m$n, p_bp_t$p_bp_errort, col="red", lwd = 1, lty=2)


#legend(  x="topright" 
#       , legend=c("Diagonal training error","Diagonal test error", "Parallel training error", "Parrallel test error")
#       , col=c("blue", "blue", "red", "red")
#       , lty=c("solid","dashed","solid","dashed")
#       , lwd=3
#       , pch=16 
#)




#Ploteamos el after prunning


pdf("ErrAP")

minY <- min(d_ap_m$d_ap_errorm, d_ap_t$d_ap_errort, p_ap_m$p_ap_errorm, p_ap_t$p_ap_errort)
maxY <- max(d_ap_m$d_ap_errorm, d_ap_t$d_ap_errort, p_ap_m$p_ap_errorm, p_ap_t$p_ap_errort)

plot(d_bp_m$n, d_ap_m$d_ap_errorm,  main = "Error After Pruning" 
    ,col="blue"
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Número de dimensiones"
    , ylab = "Error porcentual"
    , lwd = 1
    )
    
lines(d_bp_m$n, d_ap_t$d_ap_errort, col="blue", lwd = 1, lty=2)
lines(d_bp_m$n, p_ap_m$p_ap_errorm, col="red", lwd = 1)
lines(d_bp_m$n, p_ap_t$p_ap_errort, col="red", lwd = 1, lty=2)

legend(  x="topright",
         legend=c("Diagonal training error","Diagonal test error", "Parallel training error", "Parrallel test error")
       , col=c("blue", "blue", "red", "red")
       , lty=c("solid","dashed","solid","dashed")
       , lwd=3
       , pch=16 
)
