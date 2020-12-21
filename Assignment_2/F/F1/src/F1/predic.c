
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>


/*parametros de la red y el entrenamiento*/
int N1;             /* N1: NEURONAS EN CAPA DE ENTRADA */
int N2;             /* N2: NEURONAS EN CAPA INTERMEDIA */
int N3;             /* N2: NEURONAS EN CAPA DE SALIDA  */

int ITER;           /* Total de Iteraciones*/
float ETA;          /* learning rate */
float u;            /* Momentum */
int NERROR;         /* guarda mediciones de error cada NERROR iteraciones */
int WTS;            /* numero de archivo de sinapsis inicial
                       WTS=0 implica empezar la red con valores de sinapsis al azar*/

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
int NCLASES;        /* número de clases discretas*/

int DISCRETE_ERROR;       /*ERROR DISCRETO*/



/*matrices globales*/
float **data;                     /* train data */
float **test;                     /* test  data */
float **pred;                     /* salidas predichas */

/*variables globales auxiliares*/
char filepat[100];
/*bandera de error*/
int error;

/* -------------------------------------------------------------------------- */
/*define_matrix: reserva espacio en memoria para todas las matrices declaradas.
  Todas las dimensiones son leidas del archivo .net en la funcion arquitec()  */
/* -------------------------------------------------------------------------- */
int define_matrix(){

  int i,j,l,max;
  
  if(PTOT>PTEST) max=PTOT;
  else max=PTEST;



  data=(float **)calloc(PTOT,sizeof(float *));
  if(PTEST) test=(float **)calloc(PTEST,sizeof(float *));
  pred=(float **)calloc(max,sizeof(float *));
  if((PTEST&&test==NULL)||pred==NULL) return 1;


  for(i=0;i<PTOT;i++){
    data[i]=(float *)calloc(N1+1+1,sizeof(float));
	if(data[i]==NULL) return 1;
  }
  for(i=0;i<PTEST;i++){
    test[i]=(float *)calloc(N1+1+1,sizeof(float));
	if(test[i]==NULL) return 1;
  }
  for(i=0;i<PTEST;i++){
    pred[i]=(float *)calloc(N1+N3+1,sizeof(float));
	if(pred[i]==NULL) return 1;
  }




  return 0;
}
/* ---------------------------------------------------------------------------------- */
/*arquitec: Lee el archivo .net e inicializa la red en funcion de los valores leidos
  filename es el nombre del archivo .net (sin la extension) */
/* ---------------------------------------------------------------------------------- */


int arquitec(char *filename){
  FILE *b;
  int i,j;

  /*Paso 1:leer el archivo con la configuracion*/
  sprintf(filepat,"%s.temp.net",filename);
  b=fopen(filepat,"r");
  error=(b==NULL);
  if(error){
    printf("Error al abrir el archivo de parametros\n");
    return 1;
  }

  /* Estructura de la red */
  fscanf(b,"%d",&N1);
  fscanf(b,"%d",&N2);
  fscanf(b,"%d",&N3);

  /* Archivo de patrones: datos para train y para validacion */
  fscanf(b,"%d",&PTOT);
  fscanf(b,"%d",&PR);
  fscanf(b,"%d",&PTEST);

  /* Parametros para el entrenamiento */
  fscanf(b,"%d",&ITER);
  fscanf(b,"%f",&ETA);
  fscanf(b,"%f",&u);

  /* Datos para la salida de resultados */
  fscanf(b,"%d",&NERROR);

  /* Inicializacion de las sinapsis - Azar o Archivo */
  fscanf(b,"%d",&WTS);

  /* Semilla para la funcion rand()*/
  fscanf(b,"%d",&SEED);

  /* Nivel de verbosity*/
  fscanf(b,"%d",&CONTROL);

  fclose(b);



  /*Paso 2: Definir matrices para datos y pesos*/
  error=define_matrix();
  if(error){
    printf("Error en la definicion de matrices\n");
    return 1;
  }
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
  float valor;
  int i,k,l,separador;
  int max; 
  
  if(PTOT>PTEST) max=PTOT;
  else max=PTEST;
  
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
	 data[k][0]=-1.0;
 	 for(i=1;i<=N1+N3;i++){
	   fscanf(fpat,"%f",&valor);
	   data[k][i]=valor;
	   //printf ("Seteando data[%d,%d] = %f \n",k,i,valor);
	   if(CONTROL>1) printf("%f\t",data[k][i]);
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
	 test[k][0]=-1.0;
     for(i=1;i<=N1+1;i++){
	   fscanf(fpat,"%f",&valor);
	   test[k][i]=valor;
	   if(CONTROL>1) printf("%f\t",test[k][i]);
	   separador=getc(fpat);
	   if(separador!=',') ungetc(separador,fpat);
         }
  }
  fclose(fpat);
  
  //leemos las predicciones
  
  sprintf(filepat,"%s.temp.predic",filename);
  fpat=fopen(filepat,"r");
  error=(fpat==NULL);
  if(error){
    printf("Error al abrir el archivo de predicciones\n");
    return 1;
  }

  if(CONTROL>1) printf("\n\nDatos de prediccion:");

  for(k=0;k<PTEST;k++){
	 if(CONTROL>1) printf("\nP%d:\t",k);
	 pred[k][0]=-1.0;
         for(i=1;i<=N1+N3;i++){
	   fscanf(fpat,"%f",&valor);
	   pred[k][i]=valor;
	   if(CONTROL>1) printf("%f\t",test[k][i]);
	   separador=getc(fpat);
	   if(separador!=',') ungetc(separador,fpat);
         }
  }
  fclose(fpat);

  return 0;

}



/* ----------------------------------------------------------------------------------------------------- */

int create_predic(char *filename){
  FILE *fpredic;
  int i, k;

  /* Creamos el .prediction */
  sprintf(filepat,"%s.predic",filename);
  fpredic=fopen(filepat,"w");
  error=(fpredic==NULL);
  if(error){
    printf("Error creando el .prediction \n");
    return 1;
  }


  for(k=0; k < PTEST ; k++){
    for(i = 1 ;i<= N1;i++)  fprintf(fpredic,"%f\t",test[k][i]); //Copio como están las columnas de datos
    fprintf(fpredic,"%d\n",clasificar(k)); //Elijo el más grande como clase
  }

  return 0;

}


/* Clasifica un punto y actualiza el error respecto al .test*/
int clasificar(int line){
	int i;
	float max= -99;
	int class=  -1;
	for (i=0 ; i< N3 ; i++){
		if (pred[line][N1+1+i] > max) {
			max = pred[line][N1+1+i] ;
			class = i;
		}
	}
	
	if ( class!= (int)test[line][N1+1]){
		//printf ("Le erre en predecir en la linea %d, predije %d y era era %d \n",line,class,(int)test[line][N1+1]);
		DISCRETE_ERROR++;
	}
	return class;
 }


/* ----------------------------------------------------------------------------------------------------- */
int main(int argc, char **argv){

  if(argc!=2){
    printf("Modo de uso: crear_prediccion  <filename> \ndonde filename es el nombre del archivo (sin extension)\n");
    return 0;
  }

  /* leo los datos del .net */
  error=arquitec(argv[1]);
  if(error){
    printf("Error en la definicion de la red\n");
    return 1;
  }
  
  /* leo los datos .data y .test y .predic*/
  error=read_data(argv[1]);                 
  if(error){
    printf("Error en la lectura de datos\n");
    return 1;
  }

  /* creamos nuestra predicción sobre .test y vamos calculando el error discreto */
  int max;
  if(PTOT>PTEST) max=PTOT;
  else max=PTEST;

  create_predic(argv[1]);
  printf ("Error discreto: %f %% \n",(100*(float)DISCRETE_ERROR)/max);
 
}

/* ----------------------------------------------------------------------------------------------------- */












