#!/bin/bash


# TODO PARA EL DIAGONAL

# creamos los archivos que contendrán las tablas con promedios 

touch d_bp_average_errort      #valores promedio de error sobre el test before pruning
touch d_ap_average_errort      #valores promedio de error sobre el test after pruning
touch d_error_bayes              #error de bayes para cada c

# ponemos los títulos de las columnas en esas tablas
echo "C d_bp_errort" >> d_bp_average_errort
echo "C d_ap_errort" >> d_ap_average_errort
echo "C d_error_bayes" >> d_error_bayes

# hacemos lo siguiente para distintos valores de cantidad de elementos en dataset
for c in 0.5 1 1.5 2 2.5
do
	# generamos el .test
	./generador_diagonal $c 5 10000  
	rm ex1.names
	mv ex1.data ex1.test
    touch ex1.bayes
    
	#pasamos el clasificador de Bayes
	./bayes diagonal
	
	# creamos un directorio donde irán los 20 datasets de tamaño j con la distribución diagonal
	mkdir "d_dataset_${c}"
	
	# generamos los 20 datasets y los metemos en ese directorio
	for ((i = 1; i <= 20; i++)); do
		./generador_diagonal $c 5 250                    
		cp ex1.test "d_dataset_${c}/d_dataset_${c}_${i}.test"
		cp ex1.data "d_dataset_${c}/d_dataset_${c}_${i}.data"
		cp ex1.names "d_dataset_${c}/d_dataset_${c}_${i}.names"
		sleep 1
	done
	
	echo -n "$c " >>  d_error_bayes
	awk '{ total += $8 } END { print total/100 }' "ex1.bayes" >>  d_error_bayes
	mv ex1.bayes "d_dataset_${c}/d_dataset_${c}.bayes"
	
	#borramos la basura
	rm ex1.data
	rm ex1.names
	rm ex1.test

	#creamos un archivo temporal donde iremos metiendo el resultado parseado de c4.5 sobre cada dataset
	touch results

	#corre c4.5 en cada uno de los 20 datasets
	for ((i = 1; i <= 20; i++)); do

		./c4.5 -u -f "d_dataset_${c}/d_dataset_${c}_${i}" > "d_dataset_${c}/d_results_${c}_${i}.txt"
		grep  '%' "d_dataset_${c}/d_results_${c}_${i}.txt" > temp.txt #meto el resultado en un txt temporal
		./parser5         # me deja en 4+4 columnas, en results, todos los resultados útiles del c4.5
		
	done
	
	mv results "d_results_${c}"  # guardo los datos organizados en 4+4 columnitas (un solo archivo juntando los resultados de las 20 pasadas de c4.5)
	rm temp.txt                  # borro basura
	
    #voy armando la tablita de promedios. acá escribo por ejemplo para j=200 un "200 "
	echo -n "$c " >>  d_bp_average_errort
	echo -n "$c " >>  d_ap_average_errort
	
	
	#acá saco el promedio de errores y lo pongo al lado del 200. 200 9.4#
	awk '{ total += $2 } END { print total/20 }' "d_results_${c}" >>  d_bp_average_errort
	awk '{ total += $4 } END { print total/20 }' "d_results_${c}" >>  d_ap_average_errort
	
	
	mv "d_results_${c}" "d_dataset_${c}/d_results_${c}" #guardo los resultados parciales en la carpeta corespondiente para tener todo ordenadito.

done

# TODO PARA EL PARALELO

# creamos los archivos que contendrán las tablas con promedios 

touch p_bp_average_errort      #valores promedio de error sobre el test before pruning
touch p_ap_average_errort      #valores promedio de error sobre el test after pruning
touch p_error_bayes            #error de bayes para cada c

# ponemos los títulos de las columnas en esas tablas
echo "C p_bp_errort" >> p_bp_average_errort
echo "C p_ap_errort" >> p_ap_average_errort
echo "C p_error_bayes" >> p_error_bayes

# hacemos lo siguiente para distintos valores de cantidad de elementos en dataset
for c in 0.5 1 1.5 2 2.5
do
	# generamos el .test
	./generador_paralelo $c 5 10000  
	rm ex2.names
	mv ex2.data ex2.test
    touch ex2.bayes
    
	#pasamos el clasificador de Bayes
	./bayes paralelo
	
	# creamos un directorio donde irán los 20 datasets de tamaño j con la distribución diagonal
	mkdir "p_dataset_${c}"

	# generamos los 20 datasets y los metemos en ese directorio
	for ((i = 1; i <= 20; i++)); do
		./generador_paralelo $c 5 250                    
		cp ex2.test "p_dataset_${c}/p_dataset_${c}_${i}.test"
		cp ex2.data "p_dataset_${c}/p_dataset_${c}_${i}.data"
		cp ex2.names "p_dataset_${c}/p_dataset_${c}_${i}.names"
		sleep 1
	done


	echo -n "$c " >>  p_error_bayes
	awk '{ total += $8 } END { print total/100 }' "ex2.bayes" >>  p_error_bayes
	mv ex2.bayes "p_dataset_${c}/p_dataset_${c}.bayes"
	

	#borramos la basura
	rm ex2.data
	rm ex2.names
	rm ex2.test

	#creamos un archivo temporal donde iremos metiendo el resultado parseado de c4.5 sobre cada dataset
	touch results

	#corre c4.5 en cada uno de los 20 datasets
	for ((i = 1; i <= 20; i++)); do

		./c4.5 -u -f "p_dataset_${c}/p_dataset_${c}_${i}" > "p_dataset_${c}/p_results_${c}_${i}.txt"
		grep  '%' "p_dataset_${c}/p_results_${c}_${i}.txt" > temp.txt #meto el resultado en un txt temporal
		./parser5         # me deja en 4+4 columnas, en results, todos los resultados útiles del c4.5
		
	done
	
	mv results "p_results_${c}"  # guardo los datos organizados en 4+4 columnitas (un solo archivo juntando los resultados de las 20 pasadas de c4.5)
	rm temp.txt                  # borro basura
	
    #voy armando la tablita de promedios. acá escribo por ejemplo para j=200 un "200 "
	echo -n "$c " >>  p_bp_average_errort
	echo -n "$c " >>  p_ap_average_errort
	
	
	#acá saco el promedio de errores y lo pongo al lado del 200. 200 9.4#
	awk '{ total += $2 } END { print total/20 }' "p_results_${c}" >>  p_bp_average_errort
	awk '{ total += $4 } END { print total/20 }' "p_results_${c}" >>  p_ap_average_errort
	
	
	mv "p_results_${c}" "p_dataset_${c}/p_results_${c}" #guardo los resultados parciales en la carpeta corespondiente para tener todo ordenadito.

done

#GENERAMOS LOS PLOTS
Rscript plot.R
	
#LIMPIEZA

mkdir averages #acá guardo los averages desde los que se hacen los plots

mv d_bp_average_errort  averages/d_bp_average_errort    
mv d_ap_average_errort  averages/d_ap_average_errort    

mv p_bp_average_errort  averages/p_bp_average_errort    
mv p_ap_average_errort  averages/p_ap_average_errort    


mkdir datasets #acá meto todos los datasets
for j in 0.5 1 1.5 2 2.5
do
	mv "d_dataset_${j}" "datasets/d_dataset_${j}"
	mv "p_dataset_${j}" "datasets/p_dataset_${j}"
done










