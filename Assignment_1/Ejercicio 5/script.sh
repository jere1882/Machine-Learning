#!/bin/bash

# CREAMOS EL TEST

./generador_diagonal 0.78 2 10000
sleep 1
./generador_paralelo 0.78 2 10000
rm ex1.names
rm ex2.names
mv ex1.data ex1.test
mv ex2.data ex2.test

# HACEMOS TODO PARA EL DIAGONAL

# creamos los archivos que contendrán las tablas con promedios 
touch d_bp_average_errort      #valores promedio de error sobre el test before pruning
touch d_bp_average_errorm      #valores promedio de error sobre la muestra before pruning
touch d_ap_average_errort      #valores promedio de error sobre el test after pruning
touch d_ap_average_errorm      #valores promedio de error sobre la muestra after pruning

touch d_bp_average_sizet      #valores promedio de size sobre el test before pruning
touch d_bp_average_sizem      #valores promedio de size sobre la muestra before pruning
touch d_ap_average_sizet      #valores promedio de size sobre el test after pruning
touch d_ap_average_sizem      #valores promedio de size sobre la muestra after pruning


# ponemos los títulos de las columnas en esas tablas
echo "n d_bp_errort" >> d_bp_average_errort
echo "n d_bp_errorm" >> d_bp_average_errorm
echo "n d_ap_errort" >> d_ap_average_errort
echo "n d_ap_errorm" >> d_ap_average_errorm

echo "n d_bp_sizet" >> d_bp_average_sizet
echo "n d_bp_sizem" >> d_bp_average_sizem
echo "n d_ap_sizet" >> d_ap_average_sizet
echo "n d_ap_sizem" >> d_ap_average_sizem


# hacemos lo siguiente para distintos valores de cantidad de elementos en dataset
for j in 100 200 300 500 1000 5000
do
	# creamos un directorio donde irán los 20 datasets de tamaño j con la distribución diagonal
	mkdir "d_dataset_${j}e"

	# generamos los 20 datasets y los metemos en ese directorio
	for ((i = 1; i <= 20; i++)); do
		./generador_diagonal 0.78 2 $j                    
		cp ex1.test "d_dataset_${j}e/d_dataset_${j}e_${i}.test"
		cp ex1.data "d_dataset_${j}e/d_dataset_${j}e_${i}.data"
		cp ex1.names "d_dataset_${j}e/d_dataset_${j}e_${i}.names"
		sleep 1
	done

	#borramos la basura
	rm ex1.data
	rm ex1.names

	#creamos un archivo temporal donde iremos metiendo el resultado parseado de c4.5 sobre cada dataset
	touch results

	#corre c4.5 en cada uno de los 20 datasets
	for ((i = 1; i <= 20; i++)); do

		./c4.5 -u -f "d_dataset_${j}e/d_dataset_${j}e_${i}" > "d_dataset_${j}e/d_results_${j}e_${i}.txt"
		grep  '%' "d_dataset_${j}e/d_results_${j}e_${i}.txt" > temp.txt #meto el resultado en un txt temporal
		./parser5         # me deja en 4+4 columnas, en results, todos los resultados útiles del c4.5
		
	done
	
	mv results "d_results_${j}e" # guardo los % de error organizados en 4 columnitas (un solo archivo juntando los resultados de las 20 pasadas de c4.5)
	rm temp.txt                  # borro basura
	
	echo -n "$j " >>  d_bp_average_errorm #voy armando la tablita de promedios. acá escribo por ejemplo para j=200 un "200 "
	echo -n "$j " >>  d_bp_average_errort
	echo -n "$j " >>  d_ap_average_errorm
	echo -n "$j " >>  d_ap_average_errort
	
	
	echo -n "$j " >>  d_bp_average_sizem 
	echo -n "$j " >>  d_bp_average_sizet
	echo -n "$j " >>  d_ap_average_sizem
	echo -n "$j " >>  d_ap_average_sizet
	
	
	
	awk '{ total += $1 } END { print total/20 }' "d_results_${j}e" >>  d_bp_average_errorm #acá saco el promedio de errores y lo pongo al lado del 200. 200 9.4#
	awk '{ total += $2 } END { print total/20 }' "d_results_${j}e" >>  d_bp_average_errort
	awk '{ total += $3 } END { print total/20 }' "d_results_${j}e" >>  d_ap_average_errorm
	awk '{ total += $4 } END { print total/20 }' "d_results_${j}e" >>  d_ap_average_errort
	
	awk '{ total += $5 } END { print total/20 }' "d_results_${j}e" >>  d_bp_average_sizem  
	awk '{ total += $6 } END { print total/20 }' "d_results_${j}e" >>  d_bp_average_sizet
	awk '{ total += $7 } END { print total/20 }' "d_results_${j}e" >>  d_ap_average_sizem
	awk '{ total += $8 } END { print total/20 }' "d_results_${j}e" >>  d_ap_average_sizet
	
	
	
	
	mv "d_results_${j}e" "d_dataset_${j}e/d_results_${j}e" #guardo los resultados parciales en la carpeta corespondiente para tener todo ordenadito.

done

# HACEMOS TODO PARA EL PARALELO

# creamos los archivos que contendrán las tablas con promedios 
touch p_bp_average_errort      #valores promedio de error sobre el test before pruning
touch p_bp_average_errorm      #valores promedio de error sobre la muestra before pruning
touch p_ap_average_errort      #valores promedio de error sobre el test after pruning
touch p_ap_average_errorm      #valores promedio de error sobre la muestra after pruning

touch p_bp_average_sizet      #valores promedio de size sobre el test before pruning
touch p_bp_average_sizem      #valores promedio de size sobre la muestra before pruning
touch p_ap_average_sizet      #valores promedio de size sobre el test after pruning
touch p_ap_average_sizem      #valores promedio de size sobre la muestra after pruning


# ponemos los títulos de las columnas en esas tablas
echo "n p_bp_errort" >> p_bp_average_errort
echo "n p_bp_errorm" >> p_bp_average_errorm
echo "n p_ap_errort" >> p_ap_average_errort
echo "n p_ap_errorm" >> p_ap_average_errorm

echo "n p_bp_sizet" >> p_bp_average_sizet
echo "n p_bp_sizem" >> p_bp_average_sizem
echo "n p_ap_sizet" >> p_ap_average_sizet
echo "n p_ap_sizem" >> p_ap_average_sizem




# hacemos lo siguiente para distintos valores de cantidad de elementos en dataset
for j in 100 200 300 500 1000 5000
do
	# creamos un directorio donde irán los 20 datasets de tamaño j con la distribución diagonal
	mkdir "p_dataset_${j}e"

	# generamos los 20 datasets y los metemos en ese directorio
	for ((i = 1; i <= 20; i++)); do
		./generador_paralelo 0.78 2 $j              
		cp ex2.test "p_dataset_${j}e/p_dataset_${j}e_${i}.test"
		cp ex2.data "p_dataset_${j}e/p_dataset_${j}e_${i}.data"
		cp ex2.names "p_dataset_${j}e/p_dataset_${j}e_${i}.names"
		sleep 1
	done

	#borramos la basura
	rm ex2.data
	rm ex2.names

	#creamos un archivo temporal donde iremos metiendo el resultado parseado de c4.5 sobre cada dataset
	touch results

	#corre c4.5 en cada uno de los 20 datasets
	for ((i = 1; i <= 20; i++)); do

		./c4.5 -u -f "p_dataset_${j}e/p_dataset_${j}e_${i}" > "p_dataset_${j}e/p_results_${j}e_${i}.txt"
		grep  '%' "p_dataset_${j}e/p_results_${j}e_${i}.txt" > temp.txt #meto el resultado en un txt temporal
		./parser5         # me deja en 4 columnas, en results, todos los resultados útiles del c4.5
		sleep 1
		
	done
	
	mv results "p_results_${j}e" # guardo los % de error organizados en 4 columnitas (un solo archivo juntando los resultados de las 20 pasadas de c4.5)
	rm temp.txt                  # borro basura
	
	echo -n "$j " >>  p_bp_average_errorm #voy armando la tablita de promedios. acá escribo por ejemplo para j=200 un "200 "
	echo -n "$j " >>  p_bp_average_errort
	echo -n "$j " >>  p_ap_average_errorm
	echo -n "$j " >>  p_ap_average_errort
	
	
		
	echo -n "$j " >>  p_bp_average_sizem 
	echo -n "$j " >>  p_bp_average_sizet
	echo -n "$j " >>  p_ap_average_sizem
	echo -n "$j " >>  p_ap_average_sizet
	
	
	
	
	awk '{ total += $1 } END { print total/20 }' "p_results_${j}e" >>  p_bp_average_errorm #acá saco el promedio de errores y lo pongo al lado del 200. 200 9.4#
	awk '{ total += $2 } END { print total/20 }' "p_results_${j}e" >>  p_bp_average_errort
	awk '{ total += $3 } END { print total/20 }' "p_results_${j}e" >>  p_ap_average_errorm
	awk '{ total += $4 } END { print total/20 }' "p_results_${j}e" >>  p_ap_average_errort
	
	
	awk '{ total += $5 } END { print total/20 }' "p_results_${j}e" >>  p_bp_average_sizem  
	awk '{ total += $6 } END { print total/20 }' "p_results_${j}e" >>  p_bp_average_sizet
	awk '{ total += $7 } END { print total/20 }' "p_results_${j}e" >>  p_ap_average_sizem
	awk '{ total += $8 } END { print total/20 }' "p_results_${j}e" >>  p_ap_average_sizet
	
	
	
	mv "p_results_${j}e" "p_dataset_${j}e/p_results_${j}e" #guardo los resultados parciales en la carpeta corespondiente para tener todo ordenadito.

done

#GENERAMOS LOS PLOTS
Rscript plot.R
	
#LIMPIEZA

mkdir averages #acá guardo los averages desde los que se hacen los plots

mv d_bp_average_errort  averages/d_bp_average_errort    
mv d_bp_average_errorm  averages/d_bp_average_errorm    
mv d_ap_average_errort  averages/d_ap_average_errort    
mv d_ap_average_errorm  averages/d_ap_average_errorm 


mv p_bp_average_errort  averages/p_bp_average_errort    
mv p_bp_average_errorm  averages/p_bp_average_errorm    
mv p_ap_average_errort  averages/p_ap_average_errort    
mv p_ap_average_errorm  averages/p_ap_average_errorm 

mv d_bp_average_sizet  averages/d_bp_average_sizet    
mv d_bp_average_sizem  averages/d_bp_average_sizem    
mv d_ap_average_sizet  averages/d_ap_average_sizet    
mv d_ap_average_sizem  averages/d_ap_average_sizem 


mv p_bp_average_sizet  averages/p_bp_average_sizet    
mv p_bp_average_sizem  averages/p_bp_average_sizem    
mv p_ap_average_sizet  averages/p_ap_average_sizet    
mv p_ap_average_sizem  averages/p_ap_average_sizem 

mkdir datasets #acá meto todos los datasets
for j in 100 200 300 500 1000 5000
do
	mv "d_dataset_${j}e" "datasets/d_dataset_${j}e"
	mv "p_dataset_${j}e" "datasets/p_dataset_${j}e"
done










