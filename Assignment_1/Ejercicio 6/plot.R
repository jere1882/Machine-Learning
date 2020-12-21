#!/usr/bin/env Rscript

# Leemos todas las tablitas


d_bp_t <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 6/d_bp_average_errort',sep=' ')
d_ap_t <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 6/d_ap_average_errort',sep=' ')
p_bp_t <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 6/p_bp_average_errort',sep=' ')
p_ap_t <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 6/p_ap_average_errort',sep=' ')
p_bay  <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 6/p_error_bayes',sep=' ')
d_bay  <- read.csv('/home/jere/Dropbox/FACU 2017/ML/Pca 1/Ejercicio 6/d_error_bayes',sep=' ')

# Calculamos los valores maximos y minimos de y en el grafico

minY <- min(d_bp_t$d_bp_errort, p_bp_t$p_bp_errort,p_bay$p_error_bayes, d_bay$d_error_bayes)
maxY <- max(d_bp_t$d_bp_errort, p_bp_t$p_bp_errort,p_bay$p_error_bayes, d_bay$d_error_bayes)


#Ploteamos el before prunning

pdf("ErrBP")


plot(d_bp_t$C, d_bp_t$d_bp_errort, col="blue", main = "Error Before Pruning" 
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "C"
    , ylab = "Error porcentual"
    , lwd = 1
    )

lines(d_bp_t$C, p_bp_t$p_bp_errort, col="red", lwd = 1)
lines(d_bp_t$C, p_bay$p_error_bayes, col ="red", lwd=1, lty=2)
lines(d_bp_t$C, d_bay$d_error_bayes, col ="blue",lwd=1,lty=2 )

legend(  x="topright" 
       , legend=c("Diagonal test error","Parallel test error","Diagonal Bayes error","Parallel Bayes error")
       , col=c("blue", "red","blue","red")
       , lty=c("solid","solid","dashed","dashed")
       , lwd=3
       , pch=16 
)




#Ploteamos el after prunning


pdf("ErrAP")

minY <- min(d_ap_t$d_ap_errort, p_ap_t$p_ap_errort,p_bay$p_error_bayes, d_bay$d_error_bayes)
maxY <- max(d_ap_t$d_ap_errort, p_ap_t$p_ap_errort,p_bay$p_error_bayes, d_bay$d_error_bayes)

plot(d_ap_t$C, d_ap_t$d_ap_errort,  main = "Error After Pruning" 
    ,col="blue"
    , type = "l"
    , ylim = c(minY, maxY)
    , xlab = "C"
    , ylab = "Error porcentual"
    , lwd = 1
    )
    
lines(d_bp_t$C, p_ap_t$p_ap_errort, col="red", lwd = 1)
lines(d_bp_t$C, p_bay$p_error_bayes, col ="red", lwd=1, lty=2)
lines(d_bp_t$C, d_bay$d_error_bayes, col ="blue",lwd=1,lty=2 )

legend(  x="topright",
         legend=c("Diagonal test error",  "Parrallel test error","Diagonal Bayes error","Parallel Bayes error")
       , col=c("blue", "red","blue","red")
       , lty=c("solid","solid","dashed","dashed")
       , lwd=3
       , pch=16 
)



