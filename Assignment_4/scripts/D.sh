#!/bin/bash
#Let us work


#    .DIMENSIONES/.DIMENSION.K/.ITER.DIMENSION.K
CreateNetFileD () {
	touch "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"
	echo $2       >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # cantidad de entradas
	echo 2        >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # cantidad de clases 
	echo 250      >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  #.data
	echo 175      >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # training
	echo 10000    >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # cantidad de test
	echo 0        >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # semilla para el rand()
	echo 0        >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # verbosity
        echo $3       >> "paralelo.$2/paralelo.$2.$3/paralelo.$1.$2.$3.nb"  # k
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

rm masterTablep*
rm -r paralelo*


#comenzamos la nueva ejecución
touch masterTablep.csv

echo  "dim k row error" >> masterTablep.csv
for n in 2 4 8 16 32
do
mkdir "paralelo.$n"
touch "paralelo.$n/mastertTablep.$n.csv"
echo  "k row test train valid" >> masterTablep.$n.csv
for k in 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2 3 4 5 6 7
do 
	echo "[paralelo] Ejecutando $k nn con $n dimensiones"
	mkdir "paralelo.$n/paralelo.$n.$k"  
	touch "paralelo.$n/paralelo.$n.$k/error.$n.$k"
	for ((i = 1; i <= 5; i++)); do 
	   # Creo todos los archivos para poder ejecutar esta iteración
	   echo "Corrida $i / 5"
	   CreateNetFileP $i $n $k
	   cp "datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.data" "paralelo.$n/paralelo.$n.$k/paralelo.$i.$n.$k.data"
	   cp "datasets/d_dataset_${n}e/d_dataset_${n}e_${i}.test" "paralelo.$n/paralelo.$n.$k/paralelo.$i.$n.$k.test"
	   ../knn "paralelo.$n/paralelo.$n.$k/paralelo.$i.$n.$k" >> "paralelo.$n/paralelo.$n.$k/results.$i.$n.$k"
           test=$(grep "Test:" "paralelo.$n/paralelo.$n.$k/results.$i.$n.$k"           | sed 's/Test://g ; s/%//g') 
	   train=$(grep "Entrenamiento:" "paralelo.$n/paralelo.$n.$k/results.$i.$n.$k" | sed 's/Entrenamiento://g ; s/%//g')
	   valid=$(grep "Validacion:" "paralelo.$n/paralelo.$n.$k/results.$i.$n.$k"    | sed 's/Validacion://g ; s/%//g')
	   echo -n "$i " >> "paralelo.$n/paralelo.$n.$k/error.$n.$k"           
	   echo  "$test $train $valid" >>  "paralelo.$n/paralelo.$n.$k/error.$n.$k" 
	done
	echo -n "$k " >> masterTablep.$n.csv
	sort -n -k 2 "paralelo.$n/paralelo.$n.$k/error.$n.$k" | sed '2q;d' >> masterTablep.$n.csv
done 
echo -n "$n " >> masterTablep.csv
sort -n -k 5 "masterTablep.$n.csv" | sed '1q;d' >> masterTablep.csv
        
#filenumber=$(sort -n -k 2 "dos_elipses.$l.$m/error.$l.$m" | sed '10q;d' | awk '{print $1}')
#cp "dos_elipses.$l.$m/dos_elipses.$filenumber.$l.$m.mse" "ploteos/curva.$l.$m"

#pegar al lado de eso "la fila que minimice el error de validacion en mastertabled.$n"
done 



