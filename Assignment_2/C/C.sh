#!/bin/bash
#Let us work


# Función que dado el nombre, y número de ejemplos de test a usar, crea el .net
CreateNetFile () {
	touch "ikeda.$2/ikeda.$1.$2.net"
	echo 5        >> "ikeda.$2/ikeda.$1.$2.net"  # NEURONAS EN CAPA DE ENTRADA
	echo 40       >> "ikeda.$2/ikeda.$1.$2.net"  # NEURONAS EN CAPA INTERMEDIA
	echo 1        >> "ikeda.$2/ikeda.$1.$2.net"  # NEURONAS EN CAPA DE SALIDA
	echo 100      >> "ikeda.$2/ikeda.$1.$2.net"  # cantidad TOTAL de patrones en el archivo .data
	echo $2       >> "ikeda.$2/ikeda.$1.$2.net"  # cantidad de patrones de ENTRENAMIENTO
	echo 2000     >> "ikeda.$2/ikeda.$1.$2.net"  # cantidad de patrones de test (archivo .test)
	echo 20000    >> "ikeda.$2/ikeda.$1.$2.net"  # Total de Iteraciones
	echo 0.01     >> "ikeda.$2/ikeda.$1.$2.net"  # learning rate
	echo 0.3      >> "ikeda.$2/ikeda.$1.$2.net"  # Momentum
	echo 200      >> "ikeda.$2/ikeda.$1.$2.net"  # graba error cada NERROR iteraciones
	echo 0        >> "ikeda.$2/ikeda.$1.$2.net"  # numero de archivo de sinapsis inicial
	echo 0        >> "ikeda.$2/ikeda.$1.$2.net"  # semilla para el rand()
	echo 0        >> "ikeda.$2/ikeda.$1.$2.net"  # verbosity
}

#limpiamos basura que puede haber quedado de la ejecución anterior

rm masterTable.csv

rm -r ploteos
rm *.wts
rm temp*
rm -r ikeda*

#comenzamos la nueva ejecución
touch masterTable.csv
mkdir ploteos
echo  "ptr row mediana_error" >> masterTable.csv
for n in 95 75 50
do
	echo "Entrenando redes con $n % de los datos en training"
	mkdir "ikeda.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "ikeda.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 20; i++)); do
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 7"
	   CreateNetFile $i $n
	   cp "datasets/ikeda.data" "ikeda.$n/ikeda.$i.$n.data"
	   cp "datasets/ikeda.test" "ikeda.$n/ikeda.$i.$n.test"
	   sleep 0.1
	   ../bp "ikeda.$n/ikeda.$i.$n" >> "ikeda.$n/results.$i.$n"
	   echo "Se ejecutó bp con el siguiente resultado:"
	   grep "Test:" "ikeda.$n/results.$i.$n" | tail -n1 
	   grep "Test:" "ikeda.$n/results.$i.$n" | tail -n1  > temp
	   echo -n "$i " >> "ikeda.$n/error.$n"           
	   sed 's/Test://g' temp >> "ikeda.$n/error.$n"
	done
	echo -n "$n " >> masterTable.csv
	sort -n -k 2 "ikeda.$n/error.$n" | sed '10q;d' >> masterTable.csv
	filenumber=$(sort -n -k 2 "ikeda.$n/error.$n" | sed '10q;d' | awk '{print $1}')
	mv "ikeda.$n/ikeda.$filenumber.$n.mse" "ploteos/ikeda.$n"
done

Rscript plot.R

# Resultado: la tablita pedida por el ejercicio con las siguientes columnas
# NÚMERO DE NEURONAS EN CAPA INTERMEDIA  NUMERO_DE_ITERACIÓN_DONDE_APARECIO_MEDIANA_ERROR  MEDIANA_ERROR_ENTRE_LAS_20_ITERACIONES



rm *.wts
rm temp



