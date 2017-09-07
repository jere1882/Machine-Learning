#!/bin/bash
# EL ARCHIVO DEBE ESTAR EN LA CARPETA. BASENAME NO ES UN PATH

BASENAME="$1"

rm "$BASENAME.predic"

echo "Hallando predicciones para $BASENAME"
echo "Modificando archivos de entrada"

./modifica_archivos $BASENAME

echo "Entrenando red..."
./bp "$BASENAME.temp"

echo "Creando predicción y calculando error"
./predic $BASENAME

rm basura
rm *.wts
rm *.temp.*


