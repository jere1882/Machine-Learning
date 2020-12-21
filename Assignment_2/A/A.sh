#!/bin/bash
#Let us work


# Función que dado el nombre, l y  m me arma el .net
CreateNetFile () {
	touch "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"
	echo 2        >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # NEURONAS EN CAPA DE ENTRADA
	echo 6        >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # NEURONAS EN CAPA INTERMEDIA
	echo 1        >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # NEURONAS EN CAPA DE SALIDA
	echo 500      >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # cantidad TOTAL de patrones en el archivo .data
	echo 400      >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # cantidad de patrones de ENTRENAMIENTO
	echo 2000     >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # cantidad de patrones de test (archivo .test)
	echo 40000    >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # Total de Iteraciones
	echo $2       >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # learning rate
	echo $3       >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # Momentum
	echo 400      >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # graba error cada NERROR iteraciones
	echo 0        >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # numero de archivo de sinapsis inicial
	echo 0        >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # semilla para el rand()
	echo 0        >> "dos_elipses.$2.$3/dos_elipses.$1.$2.$3.net"  # verbosity
}

#limpiamos basura que puede haber quedado de la ejecución anterior
rm masterTable.csv
rm -r dos_elipses.0*
rm -r ploteos
rm *.wts
rm temp*


#comenzamos la nueva ejecución
touch masterTable.csv
mkdir ploteos
echo  "lr m row mediana_error" >> masterTable.csv
for l in 0.1 0.01 0.001
do
	for m in 0 0.5 0.9
	do
		echo "Entrenando redes con momentum = $m y learning rate = $l"
	    mkdir "dos_elipses.$l.$m"              # aca va a parar el resultado de las 20 iteraciones pra este m y este l
	    touch "dos_elipses.$l.$m/error.$l.$m"  # aca van a ir a parar todos los porcentajes de las 20 iteraciones para este m y este l 
		for ((i = 1; i <= 20; i++)); do
		   # Creo todos los archivos para poder ejecutar esta iteración
		   echo "Corrida $i / 20"
           CreateNetFile $i $l $m
           cp dos_elipses.data "dos_elipses.$l.$m/dos_elipses.$i.$l.$m.data"
           cp dos_elipses.test "dos_elipses.$l.$m/dos_elipses.$i.$l.$m.test"
		   sleep 0.1

           ../bp "dos_elipses.$l.$m/dos_elipses.$i.$l.$m" >> "dos_elipses.$l.$m/results.$i.$l.$m"
           grep "%" "dos_elipses.$l.$m/results.$i.$l.$m" > temp
		   echo -n "$i " >> "dos_elipses.$l.$m/error.$l.$m"           
           sed 's/Test discreto://g ; s/%//g' temp >> "dos_elipses.$l.$m/error.$l.$m"
        done
        echo -n "$l $m " >> masterTable.csv
        sort -n -k 2 "dos_elipses.$l.$m/error.$l.$m" | sed '10q;d' >> masterTable.csv
        filenumber=$(sort -n -k 2 "dos_elipses.$l.$m/error.$l.$m" | sed '10q;d' | awk '{print $1}')
        cp "dos_elipses.$l.$m/dos_elipses.$filenumber.$l.$m.mse" "ploteos/curva.$l.$m"
        
    done
done

echo "=) Terminado el cálculo de errores. Recolectando los datos para el ploteo"


# Resultado: la tablita pedida por el ejercicio con las siguientes columnas
# LEARNING_RATE  MOMENTUM  NUMERO_DE_ITERACIÓN_DONDE_APARECIO_MEDIANA_ERROR  MEDIANA_ERROR_ENTRE_LAS_20_ITERACIONES



rm *.wts
rm temp



