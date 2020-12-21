#!/bin/bash
#Let us work

rm *.nb

# Función que dado el nombre, y número de neuronas en capa intermedia, crea el .nb
CreateNetFileEl () {
	touch "dos_elipses.nb"
	echo 2        >> "dos_elipses.nb"  # cantidad de entradas
	echo 2        >> "dos_elipses.nb"  # cantidad de clases 
	echo 500      >> "dos_elipses.nb"  # cantidad TOTAL de patrones en el archivo .data
	echo 400      >> "dos_elipses.nb"  # cantidad de patrones de ENTRENAMIENTO
	echo 2000     >> "dos_elipses.nb"  # cantidad de patrones de test (archivo .test)
	echo 0        >> "dos_elipses.nb"  # semilla para el rand()
	echo 0        >> "dos_elipses.nb"  # verbosity
}

CreateNetFileEs () {
	touch "espirales.nb"
	echo 2        >> "espirales.nb"  # cantidad de entradas
	echo 2        >> "espirales.nb"  # cantidad de clases 
	echo 2000     >> "espirales.nb"  # cantidad TOTAL de patrones en el archivo .data
	echo 1600     >> "espirales.nb"  # cantidad de patrones de ENTRENAMIENTO
	echo 2000     >> "espirales.nb"  # cantidad de patrones de test (archivo .test)
	echo 0        >> "espirales.nb"  # semilla para el rand()
	echo 0        >> "espirales.nb"  # verbosity
}


CreateNetFileEs
CreateNetFileEl 
../nb_n espirales   > results_espirales
../nb_n dos_elipses > results_elipses
grep "Test:" results_espirales | sed 's/Test://g ; s/%//g' > error_espirales
grep "Test:" results_elipses   | sed 's/Test://g ; s/%//g' > error_elipses

Rscript plot.R


