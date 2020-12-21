#!/bin/bash
#Let us work


# Función que dado el nombre, y número de neuronas en capa intermedia, crea el .net
CreateNetFile () {
	touch "espirales.$2/espirales.$1.$2.net"
	echo 2        >> "espirales.$2/espirales.$1.$2.net"  # NEURONAS EN CAPA DE ENTRADA
	echo $2       >> "espirales.$2/espirales.$1.$2.net"  # NEURONAS EN CAPA INTERMEDIA
	echo 1        >> "espirales.$2/espirales.$1.$2.net"  # NEURONAS EN CAPA DE SALIDA
	echo 2000     >> "espirales.$2/espirales.$1.$2.net"  # cantidad TOTAL de patrones en el archivo .data
	echo 1600     >> "espirales.$2/espirales.$1.$2.net"  # cantidad de patrones de ENTRENAMIENTO
	echo 2000     >> "espirales.$2/espirales.$1.$2.net"  # cantidad de patrones de test (archivo .test)
	echo 40000    >> "espirales.$2/espirales.$1.$2.net"  # Total de Iteraciones
	echo 0.01     >> "espirales.$2/espirales.$1.$2.net"  # learning rate
	echo 0.5      >> "espirales.$2/espirales.$1.$2.net"  # Momentum
	echo 400      >> "espirales.$2/espirales.$1.$2.net"  # graba error cada NERROR iteraciones
	echo 0        >> "espirales.$2/espirales.$1.$2.net"  # numero de archivo de sinapsis inicial
	echo 0        >> "espirales.$2/espirales.$1.$2.net"  # semilla para el rand()
	echo 0        >> "espirales.$2/espirales.$1.$2.net"  # verbosity
}

#limpiamos basura que puede haber quedado de la ejecución anterior

rm masterTable.csv

rm -r ploteos
rm *.wts
rm temp*
rm -r espirales*

#comenzamos la nueva ejecución
touch masterTable.csv
mkdir ploteos
echo  "nci row mediana_error" >> masterTable.csv
for n in 2 5 10 20 40
do
	echo "Entrenando redes con $n neuronas en la capa intermedia"
	mkdir "espirales.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "espirales.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 7; i++)); do
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 7"
	   CreateNetFile $i $n
	   cp "datasets/espirales.data" "espirales.$n/espirales.$i.$n.data"
	   cp "datasets/espirales.test" "espirales.$n/espirales.$i.$n.test"
	   sleep 0.1
	   ../bp "espirales.$n/espirales.$i.$n" >> "espirales.$n/results.$i.$n"
	   grep "%" "espirales.$n/results.$i.$n" > temp
	   echo -n "$i " >> "espirales.$n/error.$n"           
	   sed 's/Test discreto://g ; s/%//g' temp >> "espirales.$n/error.$n"
	done
	echo -n "$n " >> masterTable.csv
	sort -n -k 2 "espirales.$n/error.$n" | sed '3q;d' >> masterTable.csv
	filenumber=$(sort -n -k 2 "espirales.$n/error.$n" | sed '3q;d' | awk '{print $1}')
	../discretiza "espirales.$n/espirales.$filenumber.$n"
	mv "espirales.$n/espirales.$filenumber.$n.predic.d" "ploteos/espiral.$n"
done

Rscript plot.R

# Resultado: la tablita pedida por el ejercicio con las siguientes columnas
# NÚMERO DE NEURONAS EN CAPA INTERMEDIA  NUMERO_DE_ITERACIÓN_DONDE_APARECIO_MEDIANA_ERROR  MEDIANA_ERROR_ENTRE_LAS_20_ITERACIONES



rm *.wts
rm temp



