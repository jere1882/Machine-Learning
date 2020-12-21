#!/usr/bin/env Rscript
q <- read.csv('/home/jere/Desktop/Machine Learning/TP2/A/dos_elipses.predic.d',sep='\t')

pdf("Predicc_optima.pdf")
plot(q[,1], q[,2],col=q[,3]+3, main = "Redes Mejor Caso"   , xlab = "x", ylab = "y")

