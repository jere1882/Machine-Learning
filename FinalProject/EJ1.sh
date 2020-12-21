#!/bin/bash

rm *.csv
rm optimizer_temp
rm -r heladas*

CreateNBFile () {
	touch "heladas$i/heladas-$i.original.nb"
	echo 6        >> "heladas$i/heladas-$i.original.nb"  # cantidad de entradas
	echo 2        >> "heladas$i/heladas-$i.original.nb"  # cantidad de clases 
	echo 450      >> "heladas$i/heladas-$i.original.nb"  # cantidad TOTAL de patrones en el archivo .data
	echo 450      >> "heladas$i/heladas-$i.original.nb"  # cantidad de patrones de ENTRENAMIENTO
	echo 49       >> "heladas$i/heladas-$i.original.nb"  # cantidad de patrones de test (archivo .test)
	echo 0        >> "heladas$i/heladas-$i.original.nb"  # semilla para el rand()
	echo 0        >> "heladas$i/heladas-$i.original.nb"  # verbosity
}
  
cp ds/heladas.names heladas.names
cp ds/heladas.data heladas.data

original=heladas.original.data               
validation=10

cp heladas.data $original

python sets.py

#Generate cross-validation sets
for i in `seq 0 9`; do
	mkdir "heladas$i"
	original="heladas-$i.original" # C4.5 and Naive-Bayes
	formated="heladas-$i"	   # SVM
	for j in `seq 0 9`; do
		if [ "$i" != "$j" ];
		then
			cat x$j >> "heladas$i/$original.data"
			cat xf$j >>  "heladas$i/train.dat"
		fi
	done
	cat x$i > "heladas$i/$original.test"
	cat xf$i > "heladas$i/test.dat"

	cp heladas.names "heladas$i/$original.names"
done

rm x*
rm heladas.original.data

touch c45.csv
touch nb.csv
touch lin_svm.csv
touch tan_svm.csv

#FIND THE BEST C

#FIRST SEARCH
best_c=-10
lower_bound=-10
upper_bound=20
step=`echo "scale=5;($upper_bound - $lower_bound)/15" | bc`
best_a=0
touch optimizer_temp

for i in `seq 1 2`;
do

	echo "the step is $step"
	#echo "we will check in"
	#echo `LANG=en_US seq $lower_bound $step $upper_bound`
	for c in `LANG=en_US seq $lower_bound $step $upper_bound`; do
		C=`echo "2^$c" | bc`
		./svm_learn -c $C "heladas0/train.dat" "heladas0/model" > trash
		NA=`./svm_classify "heladas0/test.dat" "heladas0/model" "heladas0/predictions" | grep "Accuracy on test set:" | sed 's/Accuracy on test set: //g ; s/%//g' | awk '{print $1}'`
		if [ $(echo "$best_a < $NA" | bc) -eq 1 ];
		then
			best_c=$c
			best_a=$NA
		fi
		echo "The actual C is $c with accuracy $NA over the 1st fold"
	done

	echo "The best C was $C with accuracy $best_a over the 1st fold"
	lower_bound=`echo "scale=5;$best_c/2" | bc`
	upper_bound=`echo "scale=5;3*($best_c/2)" | bc`
	echo "the lower bound is $lower_bound and the upper bound is $upper_bound"
	step=`echo "scale=5;($upper_bound - $lower_bound)/15" | bc`

done



best_sc=-10
best_sg=-15
best_a=0
lower_boundc=-10
lower_boundg=-15
upper_boundc=12
upper_boundg=15
stepc=1
stepg=1


for c in `LANG=en_US seq $lower_boundc $stepc $upper_boundc`; do
	C=`echo "2^$c" | bc`
for g in `LANG=en_US seq $lower_boundg $stepg $upper_boundg`; do
	G=`echo "2^$g" | bc`

	./svm_learn -c $C -t 2 -g $G "heladas0/train.dat" "heladas0/model" > trash
	NA=`./svm_classify "heladas0/test.dat" "heladas0/model" "heladas0/predictions" | grep "Accuracy on test set:" | sed 's/Accuracy on test set: //g ; s/%//g' | awk '{print $1}'`
	if [ $(echo "$best_a < $NA" | bc) -eq 1 ];
	then
		best_sc=$c
		best_sg=$g
		best_a=$NA
	fi
	echo "The actual pairs are C=$c G=$g  with accuracy $NA over the 1st fold"
done
done

echo "The best pair was c=$best_sc, a=$best_sg with accuracy $best_a"





for i in `seq 0 9`; do
	./c4.5 -u -f "heladas$i/heladas-$i.original" -u | grep '<<' | awk -F "[()]" '{gsub(/(%| )/,""); print $4}' | tail -n 1 >> c45.csv
	CreateNBFile $i
	./nb_n "heladas$i/heladas-$i.original" | grep "Test:" | sed 's/Test://g ; s/%//g' >> nb.csv
	 LC=`echo "2^$best_c" | bc`
	./svm_learn -c $LC "heladas$i/train.dat" "heladas$i/model" > trash
	./svm_classify "heladas$i/test.dat" "heladas$i/model" "heladas$i/predictions" | grep "Accuracy on test set:" | sed 's/Accuracy on test set: //g ; s/%//g' | awk '{print $1}' >> lin_svm.csv
	 RC=`echo "2^$best_sc" | bc`
	 RG=`echo "2^$best_sg" | bc`
    ./svm_learn -c $RC -t 2 -g $RG "heladas$i/train.dat" "heladas$i/model" > trash
	./svm_classify "heladas$i/test.dat" "heladas$i/model" "heladas$i/predictions" | grep "Accuracy on test set:" | sed 's/Accuracy on test set: //g ; s/%//g' | awk '{print $1}' >> rbf_svm.csv
done

rm trash
rm optimizer*

