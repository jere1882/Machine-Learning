#!/bin/bash
#Let us work


# Función que dado el nombre, y número de neuronas en capa intermedia, crea el .nb
CreateNetFileD () {
	touch "diagonal.$2/diagonal.$1.$2.nb"
	echo $2       >> "diagonal.$2/diagonal.$1.$2.nb"  # cantidad de entradas
	echo 2        >> "diagonal.$2/diagonal.$1.$2.nb"  # cantidad de clases 
	echo 175      >> "diagonal.$2/diagonal.$1.$2.nb"  # cantidad TOTAL de patrones en el archivo .data
	echo 250      >> "diagonal.$2/diagonal.$1.$2.nb"  # cantidad de patrones de ENTRENAMIENTO
	echo 10000    >> "diagonal.$2/diagonal.$1.$2.nb"  # cantidad de patrones de test (archivo .test)
	echo 0        >> "diagonal.$2/diagonal.$1.$2.nb"  # semilla para el rand()
	echo 0        >> "diagonal.$2/diagonal.$1.$2.nb"  # verbosity
}

CreateNetFileP () {
	touch "paralelo.$2/paralelo.$1.$2.nb"
	echo $2       >> "paralelo.$2/paralelo.$1.$2.nb"  # cantidad de entradas
	echo 2        >> "paralelo.$2/paralelo.$1.$2.nb"  # cantidad de clases 
	echo 175      >> "paralelo.$2/paralelo.$1.$2.nb"  # cantidad TOTAL de patrones en el archivo .data
	echo 250      >> "paralelo.$2/paralelo.$1.$2.nb"  # cantidad de patrones de ENTRENAMIENTO
	echo 10000    >> "paralelo.$2/paralelo.$1.$2.nb"  # cantidad de patrones de test (archivo .test)
	echo 0        >> "paralelo.$2/paralelo.$1.$2.nb"  # semilla para el rand()
	echo 0        >> "paralelo.$2/paralelo.$1.$2.nb"  # verbosity
}


#limpiamos basura que puede haber quedado de la ejecución anterior

rm master*
rm temp*
rm -r diagonal*
rm -r paralelo*

#comenzamos la nueva ejecución
touch masterTabled.csv

echo  "dim row error" >> masterTabled.csv
for n in 2 4 8 16 32
do
	echo "[DIAGONAL] Ejecutando bayes naive con $n dimensiones"
	mkdir "diagonal.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "diagonal.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 20; i++)); do 
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 20"
	   CreateNetFileD $i $n
	   cp "datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.data" "diagonal.$n/diagonal.$i.$n.data"
	   cp "datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.test" "diagonal.$n/diagonal.$i.$n.test"
	   ../nb_n "diagonal.$n/diagonal.$i.$n" >> "diagonal.$n/results.$i.$n"
	   grep "Test:" "diagonal.$n/results.$i.$n" > temp
	   echo -n "$i " >> "diagonal.$n/error.$n"           
	   sed 's/Test://g ; s/%//g' temp >> "diagonal.$n/error.$n"
	done
	echo -n "$n " >> masterTabled.csv
	sort -n -k 2 "diagonal.$n/error.$n" | sed '10q;d' >> masterTabled.csv
done

rm temp*


touch masterTablep.csv
echo  "dim row error" >> masterTablep.csv
for n in 2 4 8 16 32
do
	echo "[PARALELO] Entrenando bayes naive con $n dimensiones"
	mkdir "paralelo.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "paralelo.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 20; i++)); do
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 20"
	   CreateNetFileP $i $n
	   cp "datasets/p_dataset_${n}e/p_dataset_${n}e_${i}.data" "paralelo.$n/paralelo.$i.$n.data"
	   cp "datasets/p_dataset_${n}e/p_dataset_${n}e_${i}.test" "paralelo.$n/paralelo.$i.$n.test"
	   ../nb_n "paralelo.$n/paralelo.$i.$n" >> "paralelo.$n/results.$i.$n"
	   grep "Test:" "paralelo.$n/results.$i.$n" > temp
	   echo -n "$i " >> "paralelo.$n/error.$n"           
	   sed 's/Test://g ; s/%//g' temp >> "paralelo.$n/error.$n"
	done
	echo -n "$n " >> masterTablep.csv
	sort -n -k 2 "paralelo.$n/error.$n" | sed '10q;d' >> masterTablep.csv
done

# Resultado: la tablita pedida por el ejercicio con las siguientes columnas
# NÚMERO DE NEURONAS EN CAPA INTERMEDIA  NUMERO_DE_ITERACIÓN_DONDE_APARECIO_MEDIANA_ERROR  MEDIANA_ERROR_ENTRE_LAS_20_ITERACIONES

rm temp
#Rscript plot.R


