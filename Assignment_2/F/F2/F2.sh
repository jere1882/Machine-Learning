#!/bin/bash
# EL ARCHIVO DEBE ESTAR EN LA CARPETA. BASENAME NO ES UN PATH

BASENAME="$1"

rm "$BASENAME.predic"

echo "Hallando predicciones para $BASENAME"
echo "Preparando archivos para crear redes neuronales auxiliares..."

./prepara_archivos $BASENAME > temp

NUMCLASES=$(cat temp)

echo "Número de clases: 1+$NUMCLASES"
echo "Entrenando redes para cada clase..."
mkdir datasets

for i in `seq 0 $NUMCLASES`
do
	cp "$BASENAME.net" "datasets/$BASENAME.$i.net"
	mv "$BASENAME.$i.data" "datasets/$BASENAME.$i.data"
	mv "$BASENAME.$i.test" "datasets/$BASENAME.$i.test"
	./bp "datasets/$BASENAME.$i" > basura
	echo "entrenada red $i"
done

echo "Creando predicción y calculando error"
./crear_prediccion $BASENAME

rm basura
rm *.wts
rm -r datasets
rm temp

# MEJORAS: que imprima más datos en pantalla
