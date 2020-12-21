#!/bin/bash
#Let us work


CreateNetFileEl () {
	touch "dos_elipses.$2/dos_elipses.$1.$2.nb"
	echo 2        >> "dos_elipses.$2/dos_elipses.$1.$2.nb"  # cantidad de entradas
	echo 2        >> "dos_elipses.$2/dos_elipses.$1.$2.nb"  # cantidad de clases 
	echo 500     >> "dos_elipses.$2/dos_elipses.$1.$2.nb"   # cantidad TOTAL de patrones en el archivo .data
	echo 400      >> "dos_elipses.$2/dos_elipses.$1.$2.nb"  # cantidad de patrones de ENTRENAMIENTO
	echo 2000     >> "dos_elipses.$2/dos_elipses.$1.$2.nb"  # cantidad de patrones de test (archivo .test)
	echo 0        >> "dos_elipses.$2/dos_elipses.$1.$2.nb"  # semilla para el rand()
	echo 0        >> "dos_elipses.$2/dos_elipses.$1.$2.nb"  # verbosity
	echo $2       >> "dos_elipses.$2/dos_elipses.$1.$2.nb"  # bins
}

CreateNetFileEs () {
	touch "espirales.$2/espirales.$1.$2.nb"
	echo 2        >> "espirales.$2/espirales.$1.$2.nb"  # cantidad de entradas
	echo 2        >> "espirales.$2/espirales.$1.$2.nb"  # cantidad de clases 
	echo 2000     >> "espirales.$2/espirales.$1.$2.nb"  # cantidad TOTAL de patrones en el archivo .data
	echo 1600     >> "espirales.$2/espirales.$1.$2.nb"  # cantidad de patrones de ENTRENAMIENTO
	echo 2000     >> "espirales.$2/espirales.$1.$2.nb"  # cantidad de patrones de test (archivo .test)
	echo 0        >> "espirales.$2/espirales.$1.$2.nb"  # semilla para el rand()
	echo 0        >> "espirales.$2/espirales.$1.$2.nb"  # verbosity
    echo $2       >> "espirales.$2/espirales.$1.$2.nb"  # bins
}

rm *.csv
rm -r ploteosEs
rm -r ploteosEl
rm -r espirales*
rm -r dos_elipses*

#comenzamos la nueva ejecución
touch masterTableEs.csv
touch masterTableEl.csv
mkdir ploteosEs
mkdir ploteosEl
echo  "nbins nline test training validacion" >> masterTableEs.csv
echo  "nbins nline test training validacion" >> masterTableEl.csv

for ((n = 1; n <= 100; n++)); 
do
	echo "(ESPIRALES) Realizando predicciones con histogramas de $n bins"
	mkdir "espirales.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "espirales.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 21; i++)); do
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 21"
	   CreateNetFileEs $i $n
	   cp "datasets/espirales.data" "espirales.$n/espirales.$i.$n.data"
	   cp "datasets/espirales.test" "espirales.$n/espirales.$i.$n.test"
	   sleep 1
	   ../nb_hist "espirales.$n/espirales.$i.$n" >> "espirales.$n/results.$i.$n"  
	   echo -n "$i " >> "espirales.$n/error.$n" 

	   test=$(grep "Test:" "espirales.$n/results.$i.$n"           | sed 's/Test://g ; s/%//g') 
	   train=$(grep "Entrenamiento:" "espirales.$n/results.$i.$n" | sed 's/Entrenamiento://g ; s/%//g')
	   valid=$(grep "Validacion:" "espirales.$n/results.$i.$n"    | sed 's/Validacion://g ; s/%//g')
	   echo  "$test $train $valid" >>  "espirales.$n/error.$n" 
	done
	echo -n "$n " >> masterTableEs.csv
	sort -n -k 2 "espirales.$n/error.$n" | sed '10q;d' >> masterTableEs.csv
    
	filenumber=$(sort -n -k 2 "espirales.$n/error.$n" | sed '10q;d' | awk '{print $1}')
	mv "espirales.$n/espirales.$filenumber.$n.predic" "ploteosEs/espirales.$n"
done

for ((n = 1; n <= 100; n++)); 
do
	echo "(ELIPSES) Realizando predicciones con histogramas de $n bins"
	mkdir "dos_elipses.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "dos_elipses.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 21; i++)); do
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 21"
	   CreateNetFileEl $i $n
	   cp "datasets/dos_elipses.data" "dos_elipses.$n/dos_elipses.$i.$n.data"
	   cp "datasets/dos_elipses.test" "dos_elipses.$n/dos_elipses.$i.$n.test"
	   sleep 1
	   ../nb_hist "dos_elipses.$n/dos_elipses.$i.$n" >> "dos_elipses.$n/results.$i.$n"  
	   echo -n "$i " >> "dos_elipses.$n/error.$n" 

	   test=$(grep "Test:" "dos_elipses.$n/results.$i.$n"           | sed 's/Test://g ; s/%//g') 
	   train=$(grep "Entrenamiento:" "dos_elipses.$n/results.$i.$n" | sed 's/Entrenamiento://g ; s/%//g')
	   valid=$(grep "Validacion:" "dos_elipses.$n/results.$i.$n"    | sed 's/Validacion://g ; s/%//g')
	   echo  "$test $train $valid" >>  "dos_elipses.$n/error.$n" 
	done
	echo -n "$n " >> masterTableEl.csv
	sort -n -k 2 "dos_elipses.$n/error.$n" | sed '10q;d' >> masterTableEl.csv
	
	filenumber=$(sort -n -k 2 "dos_elipses.$n/error.$n" | sed '10q;d' | awk '{print $1}')
	mv "dos_elipses.$n/dos_elipses.$filenumber.$n.predic" "ploteosEl/dos_elipses.$n"
done


Rscript plot.R

# Resultado: la tablita pedida por el ejercicio con las siguientes columnas
# NÚMERO DE NEURONAS EN CAPA INTERMEDIA  NUMERO_DE_ITERACIÓN_DONDE_APARECIO_MEDIANA_ERROR  MEDIANA_ERROR_ENTRE_LAS_20_ITERACIONES







