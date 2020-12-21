#!/usr/bin/env Rscript

# Leemos todas las tablitas


dT <- read.csv('/home/jere/Escritorio/Machine Learning/TP2/E/Ejercicio 7/averages/d_ap_average_errort',sep=' ')
pT <- read.csv('/home/jere/Escritorio/Machine Learning/TP2/E/Ejercicio 7/averages/p_ap_average_errort',sep=' ')
dA <- read.csv('/home/jere/Escritorio/Machine Learning/TP2/E/masterTabled.csv',sep=' ')
pA <- read.csv('/home/jere/Escritorio/Machine Learning/TP2/E/masterTablep.csv',sep=' ')


pdf("Comparison")


minY <- min(dT$d_ap_errort, pT$p_ap_errort,  dA$mediana_error, pA$mediana_error)
maxY <- max(dT$d_ap_errort, pT$p_ap_errort, dA$mediana_error, pA$mediana_error)


plot(dT$n, dT$d_ap_errort,  main = "ANN vs TREE" 
    ,col="blue"
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "Número de dimensiones"
    , ylab = "Error porcentual"
    , lwd = 1
    )
    
lines(dT$n, pT$p_ap_errort,   col="red", lwd = 1)
lines(dT$n, dA$mediana_error, col="blue", lwd = 1,lty=2)
lines(dT$n, pA$mediana_error, col="red", lwd = 1, lty=2)

legend(  x="topright",
         legend=c("Diagonal test tree", "Diagonal test ANN","Parallel test tree", "Parrallel test ANN")
       , col=c("blue", "blue", "red", "red")
       , lty=c("solid","dashed","solid","dashed")
       , lwd=3
       , pch=16 
)
