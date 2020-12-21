
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

/* Generate random floating point numbers from min to max */
double randfrom(double min, double max) {
    double range = (max - min); 
    double div = RAND_MAX / range;
    return min + (rand() / div);
}

/* Calcula el radio de un punto */
double radio(double x, double y){
		return (sqrt(pow(x,2)+pow(y,2)));
}
/* Retorna el menor ángulo positivo en radianes */
double angle(double x, double y){
		double ans = atan2(y,x);
		if (ans < 0)
			ans += 2 * M_PI;
		if (ans > 2* M_PI)
			ans -= 2 * M_PI;
		return ans;	
} 

double ro1(double theta) {
	return (theta/(4*M_PI));
}

double ro2(double theta){
	return (theta+M_PI)/(4*M_PI);
}

// Genera un par (x,y) en dentro de la circunferencia de radio 1 centrada en (0,0)	
void generate(double*x, double *y){
	*x = randfrom(-1,1);
	*y = randfrom(-1,1);

	double r = radio(*x,*y);
	if (r>1)
		generate(x,y);
	else
		return;
} 

// Compara dos double (para qsort)
int cmp(const void *x, const void *y){
  double xx = *(double*)x, yy = *(double*)y;
  if (xx < yy) return -1;
  if (xx > yy) return  1;
  return 0;
}

int clasify(double x, double y){
	
	double r     = radio(x,y);
	double theta = angle(x,y);
	
	/* Para clasificar, lo que hago es hallar los 2 puntos de las curvas que se intersectan con la
	 * semirrecta que pasa por (0,0) y por (x,y).
	 * Hallados estos 4 puntos, es facil clasificar a (x,y) viendo entre cuales está su módulo   */
	
	
	//Empíricamente encontré que a lo sumo en 4 vueltas salen los radios que preciso.....

	double c1[5],c2[5];
	
	c1[0] = ro1(theta);
	c1[1] = ro1(theta - 2*M_PI);
	c1[2] = ro1(theta + 2*M_PI);
	c1[3] = ro1(theta - 4*M_PI);
	c1[4] = ro1(theta + 4*M_PI);


	c2[0] = ro2(theta);
    c2[1] = ro2(theta - 2*M_PI);
	c2[2] = ro2(theta + 2*M_PI);
	c2[3] = ro2(theta - 4*M_PI);	
	c2[4] = ro2(theta + 4*M_PI);
	
	/* Ordeno de menor a mayor los radios */
	qsort(c1, 5, sizeof(double), cmp);
	qsort(c2, 5, sizeof(double), cmp);
	
	int i=0,j=0;
	
	while(c1[i]<0)
		i++;
	while(c2[j]<0)
		j++;		
	
	// Estas son las 4 intersecciones de la semirecta que sale del orígen
	// y pasa por el punto (x,y) ; con las curvas ro1 y ro2
	
	double v1=c2[j];
	double v2=c2[j+1];
	double u1=c1[i];
	double u2=c1[i+1];
	
	//Analizo entre cuales de las intersecciones está
	if (y<0){
		if ( r > u2 || r < v1 || (r > u1 && r < v2))
			return 1;
		return 0;
	}
	else {
		if ( r > v2 || r < u1 || (r > v1 && r < u2))
			return 0;
		return 1;
	}	
	
}


main (int argc, char *argv[]){
	srand (time ( NULL));
	int n;


	// Obtenemos la cantidad de entradas a crear
	if (argc<2) { 	
		printf ("Ingrese el valor de n:");
		scanf("%d",&n);		
	} 
	else 
		n = atoi(argv[1]);	

	//Contadores
	int i=0,j=0;


	//Creamos los archivos donde se guardaran los datos
	FILE *f1,*f2;
    f1 = fopen ("ex3.data", "w+");
	f2 = fopen ("ex3.names", "w+");

	
	//Armamos ex1.names
	fprintf(f2, "0, 1.\n"); //Enumeramos las clases
	fprintf(f2, "\n");
	for (i=0; i<2 ; i++){
		fprintf(f2, "componente%d: continuous.\n", i+1);
	}

	fclose(f2);

/* DEBUG
	double a,b;
	while (1){
		printf("dale el a\n");
		scanf("%lf",&a);
		printf("dale el b\n");
		scanf ("%lf",&b);
		printf ("esta en la curve? %d \n", clasify2(a,b));
	
	}
*/		

	double tempx, tempy;
	i=0;
	while(i < n/2){
		generate(&tempx, &tempy);
		if (clasify(tempx, tempy)==0){
			fprintf(f1,"%lf, %lf, 0\n", tempx, tempy );
			i++;
			}
	}
	i=0;
	while(i < n/2){
	generate(&tempx, &tempy);
	if (clasify(tempx, tempy)==1){
		fprintf(f1,"%lf, %lf, 1\n", tempx, tempy );
		i++;
		}
	}
		
	fclose(f1); 
	
	

}

