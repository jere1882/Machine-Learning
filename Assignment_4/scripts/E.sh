#!/bin/bash
#Let us work


#    .DIMENSIONES/.DIMENSION.K/.ITER.DIMENSION.K
CreateNetFileD () {
	touch "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"
	echo $2       >> "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"  # cantidad de entradas
	echo 2        >> "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"  # cantidad de clases 
	echo 250      >> "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"  #.data
	echo 175      >> "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"  # training
	echo 10000    >> "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"  # cantidad de test
	echo 0        >> "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"  # semilla para el rand()
	echo 0        >> "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"  # verbosity
        echo $3       >> "diagonal.$2/diagonal.$2.$3/diagonal.$1.$2.$3.nb"  # k
}

CreateNetFileP () {
	touch "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"
	echo $2       >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # cantidad de entradas
	echo 2        >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # cantidad de clases 
	echo 250      >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  #.data
	echo 175      >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # training
	echo 10000    >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # cantidad de test
	echo 0        >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # semilla para el rand()
	echo 0        >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # verbosity
        echo $3       >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"
}


#limpiamos basura que puede haber quedado de la ejecución anterior

rm master*
rm -r diagonal*
rm -r paralelo*

#comenzamos la nueva ejecución
touch masterTabled.csv

echo  "dim k row error" >> masterTabled.csv
for n in 2 4 8 16 32
do
mkdir "diagonal.$n"
touch "diagonal.$n/masterTabled.$n.csv"
echo  "k row test train valid" >> masterTabled.$n.csv
for k in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 3 4 5 6 7
do 
	echo "[DIAGONAL] Ejecutando $k nn con $n dimensiones"
	mkdir "diagonal.$n/diagonal.$n.$k"  
	touch "diagonal.$n/diagonal.$n.$k/error.$n.$k"
	for ((i = 1; i <= 5; i++)); do 
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 5"
	   CreateNetFileD $i $n $k
	   cp "datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.data" "diagonal.$n/diagonal.$n.$k/diagonal.$i.$n.$k.data"
	   cp "datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.test" "diagonal.$n/diagonal.$n.$k/diagonal.$i.$n.$k.test"
	   ../knn_dist "diagonal.$n/diagonal.$n.$k/diagonal.$i.$n.$k" >> "diagonal.$n/diagonal.$n.$k/results.$i.$n.$k"
           test=$(grep "Test:" "diagonal.$n/diagonal.$n.$k/results.$i.$n.$k"           | sed 's/Test://g ; s/%//g') 
	   train=$(grep "Entrenamiento:" "diagonal.$n/diagonal.$n.$k/results.$i.$n.$k" | sed 's/Entrenamiento://g ; s/%//g')
	   valid=$(grep "Validacion:" "diagonal.$n/diagonal.$n.$k/results.$i.$n.$k"    | sed 's/Validacion://g ; s/%//g')
	   echo -n "$i " >> "diagonal.$n/diagonal.$n.$k/error.$n.$k"           
	   echo  "$test $train $valid" >>  "diagonal.$n/diagonal.$n.$k/error.$n.$k" 
	done
	echo -n "$k " >> masterTabled.$n.csv
	sort -n -k 2 "diagonal.$n/diagonal.$n.$k/error.$n.$k" | sed '2q;d' >> masterTabled.$n.csv
done 
echo -n "$n " >> masterTabled.csv
sort -n -k 5 "masterTabled.$n.csv" | sed '1q;d' >> masterTabled.csv
        
#filenumber=$(sort -n -k 2 "dos_elipses.$l.$m/error.$l.$m" | sed '10q;d' | awk '{print $1}')
#cp "dos_elipses.$l.$m/dos_elipses.$filenumber.$l.$m.mse" "ploteos/curva.$l.$m"

#pegar al lado de eso "la fila que minimice el error de validacion en mastertabled.$n"
done 



