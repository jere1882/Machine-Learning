#!/bin/bash


# creamos el .test

./espirales 10000 
rm ex3.names
mv ex3.data ex3.test

# hacemos lo siguiente para distintos valores de cantidad de elementos en dataset
for j in 150 600 3000
do
	sleep 1
	./espirales $j
	mkdir "espiral${j}"
	mv ex3.names "espiral${j}/espiral${j}.names"
	mv ex3.data "espiral${j}/espiral${j}.data"
	cp ex3.test "espiral${j}/espiral${j}.test"
	./c4.5 -u -f "espiral${j}/espiral${j}" >> "espiral${j}/resultados${j}"

done

rm ex3.test
Rscript plot.R

# ploteamos los .prediction




