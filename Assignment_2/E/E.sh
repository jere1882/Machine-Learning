#!/bin/bash
#Let us work


# Función que dado el nombre, y número de neuronas en capa intermedia, crea el .net
CreateNetFileD () {
	touch "diagonal.$2/diagonal.$1.$2.net"
	echo $2       >> "diagonal.$2/diagonal.$1.$2.net"  # NEURONAS EN CAPA DE ENTRADA
	echo 6        >> "diagonal.$2/diagonal.$1.$2.net"  # NEURONAS EN CAPA INTERMEDIA
	echo 1        >> "diagonal.$2/diagonal.$1.$2.net"  # NEURONAS EN CAPA DE SALIDA
	echo 250      >> "diagonal.$2/diagonal.$1.$2.net"  # cantidad TOTAL de patrones en el archivo .data
	echo 175      >> "diagonal.$2/diagonal.$1.$2.net"  # cantidad de patrones de ENTRENAMIENTO
	echo 10000    >> "diagonal.$2/diagonal.$1.$2.net"  # cantidad de patrones de test (archivo .test)
	echo 40000    >> "diagonal.$2/diagonal.$1.$2.net"  # Total de Iteraciones
	echo 0.01     >> "diagonal.$2/diagonal.$1.$2.net"  # learning rate
	echo 0.5      >> "diagonal.$2/diagonal.$1.$2.net"  # Momentum
	echo 400      >> "diagonal.$2/diagonal.$1.$2.net"  # graba error cada NERROR iteraciones
	echo 0        >> "diagonal.$2/diagonal.$1.$2.net"  # numero de archivo de sinapsis inicial
	echo 0        >> "diagonal.$2/diagonal.$1.$2.net"  # semilla para el rand()
	echo 0        >> "diagonal.$2/diagonal.$1.$2.net"  # verbosity
}

CreateNetFileP () {
	touch "paralelo.$2/paralelo.$1.$2.net"
	echo $2       >> "paralelo.$2/paralelo.$1.$2.net"  # NEURONAS EN CAPA DE ENTRADA
	echo 6        >> "paralelo.$2/paralelo.$1.$2.net"  # NEURONAS EN CAPA INTERMEDIA
	echo 1        >> "paralelo.$2/paralelo.$1.$2.net"  # NEURONAS EN CAPA DE SALIDA
	echo 250      >> "paralelo.$2/paralelo.$1.$2.net"  # cantidad TOTAL de patrones en el archivo .data
	echo 175      >> "paralelo.$2/paralelo.$1.$2.net"  # cantidad de patrones de ENTRENAMIENTO
	echo 10000    >> "paralelo.$2/paralelo.$1.$2.net"  # cantidad de patrones de test (archivo .test)
	echo 40000    >> "paralelo.$2/paralelo.$1.$2.net"  # Total de Iteraciones
	echo 0.01     >> "paralelo.$2/paralelo.$1.$2.net"  # learning rate
	echo 0.5      >> "paralelo.$2/paralelo.$1.$2.net"  # Momentum
	echo 400      >> "paralelo.$2/paralelo.$1.$2.net"  # graba error cada NERROR iteraciones
	echo 0        >> "paralelo.$2/paralelo.$1.$2.net"  # numero de archivo de sinapsis inicial
	echo 0        >> "paralelo.$2/paralelo.$1.$2.net"  # semilla para el rand()
	echo 0        >> "paralelo.$2/paralelo.$1.$2.net"  # verbosity
}


#limpiamos basura que puede haber quedado de la ejecución anterior

rm *.csv
rm -r ploteos
rm *.wts
rm temp*
rm -r diagonal*
rm -r paralelo*

#comenzamos la nueva ejecución
touch masterTabled.csv
mkdir ploteos
echo  "dim row mediana_error" >> masterTabled.csv
for n in 2 4 8 16 32
do
	echo "[DIAGONAL] Entrenando redes con $n neuronas de entrada"
	mkdir "diagonal.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "diagonal.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 20; i++)); do
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 20"
	   CreateNetFileD $i $n
	   cp "Ejercicio 7/datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.data" "diagonal.$n/diagonal.$i.$n.data"
	   cp "Ejercicio 7/datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.test" "diagonal.$n/diagonal.$i.$n.test"
	   sleep 0.1
	   ../bp "diagonal.$n/diagonal.$i.$n" >> "diagonal.$n/results.$i.$n"
	   grep "%" "diagonal.$n/results.$i.$n" > temp
	   echo -n "$i " >> "diagonal.$n/error.$n"           
	   sed 's/Test discreto://g ; s/%//g' temp >> "diagonal.$n/error.$n"
	done
	echo -n "$n " >> masterTabled.csv
	sort -n -k 2 "diagonal.$n/error.$n" | sed '10q;d' >> masterTabled.csv
	filenumber=$(sort -n -k 2 "diagonal.$n/error.$n" | sed '10q;d' | awk '{print $1}')
    cp "diagonal.$n/diagonal.$filenumber.$n.mse" "ploteos/diagonal.$n"
        
        
done

rm temp*
rm *.wts

touch masterTablep.csv
echo  "dim row mediana_error" >> masterTablep.csv
for n in 2 4 8 16 32
do
	echo "[PARALELO] Entrenando redes con $n neuronas de entrada"
	mkdir "paralelo.$n"           # aca va a parar el resultado de las 20 iteraciones pra este n
	touch "paralelo.$n/error.$n"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este n
	for ((i = 1; i <= 20; i++)); do
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 20"
	   CreateNetFileP $i $n
	   cp "Ejercicio 7/datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.data" "paralelo.$n/paralelo.$i.$n.data"
	   cp "Ejercicio 7/datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.test" "paralelo.$n/paralelo.$i.$n.test"
	   sleep 0.1
	   ../bp "paralelo.$n/paralelo.$i.$n" >> "paralelo.$n/results.$i.$n"
	   grep "%" "paralelo.$n/results.$i.$n" > temp
	   echo -n "$i " >> "paralelo.$n/error.$n"           
	   sed 's/Test discreto://g ; s/%//g' temp >> "paralelo.$n/error.$n"
	done
	echo -n "$n " >> masterTablep.csv
	sort -n -k 2 "paralelo.$n/error.$n" | sed '10q;d' >> masterTablep.csv
	filenumber=$(sort -n -k 2 "paralelo.$n/error.$n" | sed '10q;d' | awk '{print $1}')
    cp "paralelo.$n/paralelo.$filenumber.$n.mse" "ploteos/paralelo.$n"
        
        
done

# Resultado: la tablita pedida por el ejercicio con las siguientes columnas
# NÚMERO DE NEURONAS EN CAPA INTERMEDIA  NUMERO_DE_ITERACIÓN_DONDE_APARECIO_MEDIANA_ERROR  MEDIANA_ERROR_ENTRE_LAS_20_ITERACIONES



rm *.wts
rm temp
Rscript plot.R


