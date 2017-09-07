/*
nb_n.c : Clasificador Naive Bayes usando la aproximacion con histogramas para features continuos
Formato de datos: c4.5
La clase a predecir tiene que ser un numero comenzando de 0: por ejemplo, para 3 clases, las clases deben ser 0,1,2

PMG - Ultima revision: 20/06/2001
*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#define LOW 1.e-14                 /*Minimo valor posible para una probabilidad*/
#define PI  3.141592653


int N_IN;           /*Total numbre of inputs*/
int N_Class;        /*Total number of classes (outputs)*/

int PTOT;           /* cantidad TOTAL de patrones en el archivo .data */
int PR;             /* cantidad de patrones de ENTRENAMIENTO */
int PTEST;          /* cantidad de patrones de TEST (archivo .test) */
                    /* cantidad de patrones de VALIDACION: PTOT - PR*/

int SEED;           /* semilla para la funcion rand(). Los posibles valores son:*/
                    /* SEED: -1: No mezclar los patrones: usar los primeros PR para entrenar
                                 y el resto para validar.Toma la semilla del rand con el reloj.
                              0: Seleccionar semilla con el reloj, y mezclar los patrones.
                             >0: Usa el numero leido como semilla, y mezcla los patrones. */

int CONTROL;        /* nivel de verbosity: 0 -> solo resumen, 1 -> 0 + pesos, 2 -> 1 + datos*/

int N_TOTAL;        /*Numero de patrones a usar durante el entrenamiento*/
int N_BINS;         /*Número de bins por feature por clase*/

/*matrices globales */

double **data;                     /* train data */
double **test;                     /* test  data */
int    *pred;                      /* clases predichas */
int    *nejs;                      /* cantidad de elementos de cada clase */
double *p_clase;                   /* probabilidad a priori de que un punto sea de cada clase */
int    *seq;          		       /* sequencia de presentacion de los patrones*/
 
double ****bins;                     /* la probabilidad para cada bin  */
double *min_feature;                /* límite inferior del cubo cada cada feature */
double *max_feature;                /* límite superior del cubo para cada feature*/
/*variables globales auxiliares*/
char filepat[100];
/*bandera de error*/
int error;


/* -------------------------------------------------------------------------- */
/*define_matrix: reserva espacio en memoria para todas las matrices declaradas.
  Todas las dimensiones son leidas del archivo .nb en la funcion arquitec()  */
/* -------------------------------------------------------------------------- */
int define_matrix(){

  int i,j,k,max;
  if(PTOT>PTEST) max=PTOT;
  else max=PTEST;

  seq =(int *)calloc(max,sizeof(int));
  pred=(int *)calloc(max,sizeof(int));
  if(seq==NULL||pred==NULL) return 1;
  
  data=(double **)calloc(PTOT,sizeof(double *));
  if(PTEST) test=(double **)calloc(PTEST,sizeof(double *));
  if(data==NULL||(PTEST&&test==NULL)) return 1;

  for(i=0;i<PTOT;i++){
    data[i]=(double *)calloc(N_IN+1,sizeof(double));
	if(data[i]==NULL) return 1;
  }
  for(i=0;i<PTEST;i++){
    test[i]=(double *)calloc(N_IN+1,sizeof(double));
	if(test[i]==NULL) return 1;
  }


  nejs = (int *) calloc(N_Class,sizeof(int));
  p_clase = (double *) calloc(N_Class,sizeof(double));


	bins = (double ****)calloc(N_Class, sizeof(double***));
	for(i = 0; i < N_Class; i++) {
		bins[i] = (double***)calloc(N_BINS, sizeof(double**));
		for(j = 0; j < N_BINS; j++) {
			bins[i][j] = (double**)calloc(N_BINS, sizeof(double*));
			for (k=0 ; k < N_BINS ; k++)
			   bins[i][j][k]= (double *) calloc (N_BINS, sizeof(double));
		}
	}
	
  min_feature = (double*) calloc (N_IN,sizeof(double));
  max_feature = (double*) calloc (N_IN,sizeof(double));
  
  return 0;
}
/* ---------------------------------------------------------------------------------- */
/*arquitec: Lee el archivo .nb e inicializa el algoritmo en funcion de los valores leidos
  filename es el nombre del archivo .nb (sin la extension) */
/* ---------------------------------------------------------------------------------- */
int arquitec(char *filename){
  FILE *b;
  time_t t;

  /*Paso 1:leer el archivo con la configuracion*/
  sprintf(filepat,"%s.nb",filename);
  b=fopen(filepat,"r");
  error=(b==NULL);
  if(error){
    printf("Error al abrir el archivo de parametros\n");
    return 1;
  }

  /* Dimensiones */
  fscanf(b,"%d",&N_IN);
  fscanf(b,"%d",&N_Class);

  /* Archivo de patrones: datos para train y para validacion */
  fscanf(b,"%d",&PTOT);
  fscanf(b,"%d",&PR);
  fscanf(b,"%d",&PTEST);

  /* Semilla para la funcion rand()*/
  fscanf(b,"%d",&SEED);

  /* Nivel de verbosity*/
  fscanf(b,"%d",&CONTROL);

  /* Número de bins */
  fscanf(b,"%d",&N_BINS);
  fclose(b);

  // printf("Hasta acá vamos bien\n");

  /*Paso 2: Definir matrices para datos y parametros (e inicializarlos*/
  error=define_matrix();
  if(error){
    printf("Error en la definicion de matrices\n");
    return 1;
  }

  /* Chequear semilla para la funcion rand() */
  if(SEED==0) SEED=time(&t);

  /*Imprimir control por pantalla*/
  printf("\nNaive Bayes con distribuciones normales:\nCantidad de entradas:%d",N_IN);
  printf("\nCantidad de clases:%d",N_Class);
  printf("\nArchivo de patrones: %s",filename);
  printf("\nCantidad total de patrones: %d",PTOT);
  printf("\nCantidad de patrones de entrenamiento: %d",PR);
  printf("\nCantidad de patrones de validacion: %d",PTOT-PR);
  printf("\nCantidad de patrones de test: %d",PTEST);
  printf("\nSemilla para la funcion rand(): %d",SEED); 
  printf("\nCantidad de bins: %d",N_BINS);

  return 0;
}
/* -------------------------------------------------------------------------------------- */
/*read_data: lee los datos de los archivos de entrenamiento(.data) y test(.test)
  filename es el nombre de los archivos (sin extension)
  La cantidad de datos y la estructura de los archivos fue leida en la funcion arquitec()
  Los registros en el archivo pueden estar separados por blancos ( o tab ) o por comas    */
/* -------------------------------------------------------------------------------------- */
int read_data(char *filename){

  FILE *fpat;
  double valor;
  int i,k,separador;

  sprintf(filepat,"%s.data",filename);
  fpat=fopen(filepat,"r");
  error=(fpat==NULL);
  if(error){
    printf("Error al abrir el archivo de datos\n");
    return 1;
  }

  if(CONTROL>1) printf("\n\nDatos de entrenamiento:");

  for(k=0;k<PTOT;k++){
    if(CONTROL>1) printf("\nP%d:\t",k);
    for(i=0;i<N_IN+1;i++){
      fscanf(fpat,"%lf",&valor);
      data[k][i]=valor;
      if(CONTROL>1) printf("%lf\t",data[k][i]);
      separador=getc(fpat);
      if(separador!=',') ungetc(separador,fpat);
    }
  }
  fclose(fpat);

  if(!PTEST) return 0;

  sprintf(filepat,"%s.test",filename);
  fpat=fopen(filepat,"r");
  error=(fpat==NULL);
  if(error){
    printf("Error al abrir el archivo de test\n");
    return 1;
  }

  if(CONTROL>1) printf("\n\nDatos de test:");

  for(k=0;k<PTEST;k++){
    if(CONTROL>1) printf("\nP%d:\t",k);
    for(i=0;i<N_IN+1;i++){
      fscanf(fpat,"%lf",&valor);
      test[k][i]=valor;
      if(CONTROL>1) printf("%lf\t",test[k][i]);
      separador=getc(fpat);
      if(separador!=',') ungetc(separador,fpat);
    }
  }
  fclose(fpat);

  return 0;

}
/* ------------------------------------------------------------ */
/* shuffle: mezcla el vector seq al azar.
   El vector seq es un indice para acceder a los patrones.
   Los patrones mezclados van desde seq[0] hasta seq[hasta-1]
   Esto permite separar la parte de validacion de la de train   */
/* ------------------------------------------------------------ */
void shuffle(int hasta){
   double x;
   int tmp;
   int top,select;

   top=hasta-1;
   while (top > 0) {
	x = (double)rand();
	x /= RAND_MAX;
	x *= (top+1);
	select = (int)x;
	tmp = seq[top];
	seq[top] = seq[select];
	seq[select] = tmp;
	top --;
   }
  if(CONTROL>3) {printf("End shuffle\n");fflush(NULL);}
}


int hallar_cubeta(double *x, int feature){ // Halla el índice de la cubeta correspondiente a x en la dimensión feature
	if (feature>=N_IN)
		return 0;
	double ancho_cubeta = (max_feature[feature]-min_feature[feature])/(double)N_BINS;
	if (ancho_cubeta<0) ancho_cubeta*=-1;	
	int i;
	for (i=0; i<N_BINS; i++){
       if (x[feature] <= min_feature[feature] + (i+1)*ancho_cubeta) return i;
	}
	return (N_BINS-1);
}

/* ------------------------------------------------------------------- */
/*Prob:Calcula la probabilidad de obtener el valor x para el input feature y la clase clase
  Aproxima las probabilidades por distribuciones normales */
/* ------------------------------------------------------------------- */
double prob(double *x,int clase)  { 
	int ind_x = hallar_cubeta(x,0);
	int ind_y = hallar_cubeta(x,1);
    int ind_z = hallar_cubeta(x,2);
	return bins[clase][ind_x][ind_y][ind_z];	
}

/* ------------------------------------------------------------------------------ */
/*output: calcula la probabilidad de cada clase dado un vector de entrada *input
  usa el log(p(x)) (sumado)
  devuelve la de mayor probabilidad                                               */
/* ------------------------------------------------------------------------------ */
int output(double *input){
   	
  double prob_de_clase;
  double max_prob=-1e40;
  int k,clase_MAP;
  for(k=0;k<N_Class;k++) {
    prob_de_clase=0.;

    /*calcula la probabilidad de que ese punto sea de esa clase*/
    prob_de_clase += log( prob( input , k ) );

    /*agrega la probabilidad a priori de la clase*/
    prob_de_clase += log(p_clase[k]);   

    /*guarda la clase con prob maxima*/
    if (prob_de_clase>=max_prob){
      max_prob=prob_de_clase;
      clase_MAP=k;
    }
  }
  
  return clase_MAP;
}

/* ------------------------------------------------------------------------------ */
/*propagar: calcula las clases predichas para un conjunto de datos
  la matriz S tiene que tener el formato adecuado ( definido en arquitec() )
  pat_ini y pat_fin son los extremos a tomar en la matriz
  usar_seq define si se accede a los datos directamente o a travez del indice seq
  los resultados (las propagaciones) se guardan en la matriz seq                  */
/* ------------------------------------------------------------------------------ */
double propagar(double **S,int pat_ini,int pat_fin,int usar_seq){

  double mse=0.0;
  int nu;
  int patron;
  
  for (patron=pat_ini; patron < pat_fin; patron ++) {

   /*nu tiene el numero del patron que se va a presentar*/
    if(usar_seq) nu = seq[patron];
    else         nu = patron;

    /*clase MAP para el patron nu*/
    pred[nu]=output(S[nu]);

    /*actualizar error*/
    if(S[nu][N_IN]!=(double)pred[nu]) mse+=1.;
  }
    

  mse /= ( (double)(pat_fin-pat_ini));

  if(CONTROL>3) {printf("End prop\n");fflush(NULL);}

  return mse;
}

/* --------------------------------------------------------------------------------------- */
/*train: ajusta los parametros del algoritmo a los datos de entrenamiento
         guarda los parametros en un archivo de control
         calcula porcentaje de error en ajuste y test                                      */
/* --------------------------------------------------------------------------------------- */
int train(char *filename){

  //printf("Empezando train\n");

  int i,j,k,feature,clase;
  double train_error,valid_error,test_error;
  FILE *salida,*fpredic;

  /*Asigno todos los patrones del .data como entrenamiento porque este metodo no requiere validacion*/
  //N_TOTAL=PTOT;
  N_TOTAL=PR; /*si hay validacion*/
   // printf("Usamos %d puntos \n",N_TOTAL);
  for(k=0;k<PTOT;k++) seq[k]=k;  /* inicializacion del indice de acceso a los datos */

  /*efectuar shuffle inicial de los datos de entrenamiento si SEED != -1 (y hay validacion)*/
  if(SEED>-1 && N_TOTAL<PTOT){
    srand((unsigned)SEED);    
    shuffle(PTOT);
  }
  
  /*Calcular cuantos elementos hay por clase */
	for (i=0; i < N_TOTAL ; i++)
		nejs[(int)data[seq[i]][N_IN]] += 1;

  /*Calcular probabilidad intrinseca de cada clase*/
	for (i=0 ; i < N_Class ; i++)
		p_clase[i] = (double) nejs[i] / (double) N_TOTAL;


   /*Armo los límites de cada conjunto de cubetas dado feature y class */
   /*distingo entre cada clase. Dado un feature, no son iguales los limites de todas las cubetas
    * para distintas clases. ME fijo para cada clase límites adecuados */
    
    float x;
    int class;
    /* Hallo los límites de cada feature para armar las cubetas */
    
    for (j=0 ; j < N_IN ; j++){
		min_feature[j] = max_feature[j] =data[seq[0]][j];
		for (k=1 ; k < N_TOTAL ; k++) {
			if (min_feature[j] > data[seq[k]][j]) min_feature[j] = data[seq[k]][j];
			if (max_feature[j] < data[seq[k]][j]) max_feature[j] = data[seq[k]][j];
		}
    }
  
  

   /* Armo los histogramas por cada clase */
    int cubetax, cubetay, cubetaz;
   
	for (k=0; k< N_TOTAL ; k++) {
		class = (int) data[seq[k]][N_IN];
		cubetax = hallar_cubeta(data[seq[k]],0);
		cubetay = hallar_cubeta(data[seq[k]],1);
		cubetaz = hallar_cubeta(data[seq[k]],2);
		bins[class][cubetax][cubetay][cubetaz]++;
	}


	int l;
	for (k=0; k< N_Class ; k++) {
		for (i = 0; i<N_BINS; i++){
			for (j = 0 ; j < N_BINS ; j++) {
				for (l = 0 ; l < N_BINS ; l++) {
					bins[k][i][j][l] +=1;  // sumo p.m
					bins[k][i][j][l] /= nejs[k] + N_BINS;  // divido por n+m
				}
			}
		}
	}
	


  /*calcular error de entrenamiento*/
  train_error=propagar(data,0,PR,1);
  /*calcular error de validacion; si no hay, usar mse_train*/
  if(PR==PTOT) valid_error=train_error;
  else         valid_error=propagar(data,PR,PTOT,1);
  /*calcular error de test (si hay)*/
  if (PTEST>0) test_error =propagar(test,0,PTEST,0);
  else         test_error =0.;
  /*mostrar errores*/
  printf("\nFin del entrenamiento.\n\n");
  printf("Errores:\nEntrenamiento:%f%%\n",train_error*100.);
  printf("Validacion:%f%%\nTest:%f%%\n",valid_error*100.,test_error*100.);
  if(CONTROL) fflush(NULL);

  /* archivo de predicciones */
  sprintf(filepat,"%s.predic",filename);
  fpredic=fopen(filepat,"w");
  error=(fpredic==NULL);
  if(error){
    printf("Error al abrir archivo para guardar predicciones\n");
    return 1;
  }
  for(k=0; k < PTEST ; k++){
    for( i = 0 ;i< N_IN;i++) fprintf(fpredic,"%f\t",test[k][i]);
    fprintf(fpredic,"%d\n",pred[k]);
  }
  fclose(fpredic);

  return 0;
}

/* ----------------------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------- */
int main(int argc, char **argv){

  if(argc!=2){
    printf("Modo de uso: nb <filename>\ndonde filename es el nombre del archivo (sin extension)\n");
    return 0;
  }

  /* defino la estructura*/
  error=arquitec(argv[1]);
  if(error){
    printf("Error en la definicion de parametros\n");
    return 1;
  }

  if (N_IN >= 3){
     printf ("Datasets debe tener menos de 3 dimensiones\n");
     return 1; 
	 }
  
  /* leo los datos */
  error=read_data(argv[1]);                 
  if(error){
    printf("Error en la lectura de datos\n");
    return 1;
  }

  /* ajusto los parametros y calcula errores en ajuste y test*/
  error=train(argv[1]);                     
  if(error){
    printf("Error en el ajuste\n");
    return 1;
  }


  return 0;

}
/* ----------------------------------------------------------------------------------------------------- */

