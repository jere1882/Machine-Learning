#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>


/* the Gaussian probability distribution  */
float normal(double mu, double sigma, double x) {
	double denom = sqrt(2 * pow(sigma,2) * M_PI);
	double num   = exp(-pow((x-mu),2)/(2*pow(sigma,2)));
	return (num/denom);
}

/* Generate random floating point numbers from min to max */
double randfrom(double min, double max) 
{
    double range = (max - min); 
    double div = RAND_MAX / range;
    return min + (rand() / div);
}

/* Generate random numbers following a normal distribution */
double genera_normal(double mu, double sigma){
	double x = randfrom(mu-5.0*sigma, mu+5.0*sigma);
	double y = randfrom(0,1.0/sqrt(2.0*M_PI*sigma));
	if (normal(mu,sigma,x)>y) 
		return(x);
	else 
		return(genera_normal(mu,sigma));	
}



main (int argc, char *argv[]){
	srand (time ( NULL));

	double c;
	int d,n;
	double mu,sigma;

	/* Obtenemos todos los parametros de los datos a generar */
	if (argc<4) { 	
		printf ("Ingrese el valor de C:");
		scanf ("%lf",&c);
		printf ("Ingrese el valor de d:");
		scanf ("%d",&d);
		printf ("Ingrese el valor de n:");
		scanf("%d",&n);		
	} 
	else {
		c = atof(argv[1]);
		d = atoi(argv[2]);
		n = atoi(argv[3]);	
	}

	
	// Parámetros de la distribucion normal
	sigma = c * sqrt(d);

	
	//Contadores
	int i,j;


	//Creamos los archivos donde se guardaran los datos
	FILE *f1,*f2;
    	f1 = fopen ("ex1.data", "w+");
	f2 = fopen ("ex1.names", "w+");

	
	//Armamos ex1.names
	fprintf(f2, "0, 1.\n"); //Enumeramos las clases
	fprintf(f2, "\n");
	for (i=0; i<d ; i++){
		fprintf(f2, "componente%d: continuous.\n", i+1);
	}

	fclose(f2);

	//Creamos los n/2 elementos de clase 1
	mu = 1.0;
	for (i=0; i < n/2 ; i++){       // n/2 filas
		for (j=0; j<d ; j++ )   // d columnas
		   fprintf(f1,"%lf,  ", genera_normal(mu,sigma) );
		fprintf(f1,"1\n");	
	}


	//Creamos los n/2 elementos de clase 0
	mu = -1;

        for (i=0; i < n/2 ; i++){       // n/2 filas
                for (j=0; j<d ; j++ )   // d columnas
                   fprintf(f1,"%lf,  ", genera_normal(mu,sigma) );
                fprintf(f1,"0\n");      
        } 
	fclose(f1); 

}
