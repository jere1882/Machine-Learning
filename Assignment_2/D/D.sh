#!/bin/bash
#Let us work


# Función que dado el nombre, y número de neuronas en capa intermedia, crea el .net
CreateNetFile () {
	touch "ssp.$2/ssp.$1.$2.net"
	echo 12       >> "ssp.$2/ssp.$1.$2.net"  # NEURONAS EN CAPA DE ENTRADA
	echo 6        >> "ssp.$2/ssp.$1.$2.net"  # NEURONAS EN CAPA INTERMEDIA
	echo 1        >> "ssp.$2/ssp.$1.$2.net"  # NEURONAS EN CAPA DE SALIDA
	echo 180      >> "ssp.$2/ssp.$1.$2.net"  # cantidad TOTAL de patrones en el archivo .data
	echo 180      >> "ssp.$2/ssp.$1.$2.net"  # cantidad de patrones de ENTRENAMIENTO
	echo 107      >> "ssp.$2/ssp.$1.$2.net"  # cantidad de patrones de test (archivo .test)
	echo 100000   >> "ssp.$2/ssp.$1.$2.net"  # Total de Iteraciones
	echo 0.01     >> "ssp.$2/ssp.$1.$2.net"  # learning rate
	echo 0.3      >> "ssp.$2/ssp.$1.$2.net"  # Momentum
	echo 200      >> "ssp.$2/ssp.$1.$2.net"  # graba error cada NERROR iteraciones
	echo 0        >> "ssp.$2/ssp.$1.$2.net"  # numero de archivo de sinapsis inicial
	echo 0        >> "ssp.$2/ssp.$1.$2.net"  # semilla para el rand()
	echo 0        >> "ssp.$2/ssp.$1.$2.net"  # verbosity
	echo $2       >> "ssp.$2/ssp.$1.$2.net"  # gamma weight decay
}

#limpiamos basura que puede haber quedado de la ejecución anterior

rm masterTable.csv

rm -r ploteos
rm *.wts
rm temp*


#comenzamos la nueva ejecución
touch masterTable.csv
mkdir ploteos
echo  "nci row mediana_error" >> masterTable.csv
rm -r ssp.*

for n in 0.00000001 0.0000001 0.000001 0.00001 0.0001 0.001 0.01 0.1 1
do
	echo "Entrenando redes usando weight decay. gamma = $n"
	mkdir "ssp.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "ssp.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 5; i++)); do
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 5"
	   CreateNetFile $i $n
	   cp "datasets/ssp.data" "ssp.$n/ssp.$i.$n.data"
	   cp "datasets/ssp.test" "ssp.$n/ssp.$i.$n.test"
	   sleep 0.1
	   ./bp "ssp.$n/ssp.$i.$n" >> "ssp.$n/results.$i.$n"
	   grep "Test:" "ssp.$n/results.$i.$n" | head -n 1 > temp
	   echo -n "$i " >> "ssp.$n/error.$n"           
	   sed 's/Test://g' temp >> "ssp.$n/error.$n"
	done
	echo -n "$n " >> masterTable.csv
	sort -n -k 2 "ssp.$n/error.$n" | sed '2q;d' >> masterTable.csv
	filenumber=$(sort -n -k 2 "ssp.$n/error.$n" | sed '2q;d' | awk '{print $1}')
	mv "ssp.$n/ssp.$filenumber.$n.mse" "ploteos/ssp.$n"
done

# Resultado: la tablita pedida por el ejercicio con las siguientes columnas
# NÚMERO DE NEURONAS EN CAPA INTERMEDIA  NUMERO_DE_ITERACIÓN_DONDE_APARECIO_MEDIANA_ERROR  MEDIANA_ERROR_ENTRE_LAS_20_ITERACIONES



rm *.wts
rm temp



