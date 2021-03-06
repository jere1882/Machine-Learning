
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

  int i,j,max;
  
  if(PTOT>PTEST) max=PTOT;
  else max=PTEST;



  data=(float **)calloc(PTOT,sizeof(float *));
  if(PTEST) test=(float **)calloc(PTEST,sizeof(float *));
  pred=(float **)calloc(max,sizeof(float *));
  if((PTEST&&test==NULL)||pred==NULL) return 1;


  for(i=0;i<PTOT;i++){
    data[i]=(float *)calloc(N1+N3+1,sizeof(float));
	if(data[i]==NULL) return 1;
  }
  for(i=0;i<PTEST;i++){
    test[i]=(float *)calloc(N1+N3+1,sizeof(float));
	if(test[i]==NULL) return 1;
  }
  for(i=0;i<max;i++){
    pred[i]=(float *)calloc(N3+1,sizeof(float));
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
  sprintf(filepat,"%s.net",filename);
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
         for(i=1;i<=N1+N3;i++){
	   fscanf(fpat,"%f",&valor);
	   test[k][i]=valor;
	   if(CONTROL>1) printf("%f\t",test[k][i]);
	   separador=getc(fpat);
	   if(separador!=',') ungetc(separador,fpat);
         }
  }
  fclose(fpat);

  int maxclass=-1;
  
  for (i=0; i<PTOT; i++){
	//printf ("La clase de la fila %d es %d \n",i,  (int) data[i][N1+1]);
	if (data[i][N1+1] > maxclass){
		maxclass = (int) data[i][N1+1];
	//	printf("Encontramos una nueva clase! %d en data linea %d\n",(int)data[i][N1+1],i);
	}
  }
  if(PTEST){
	  for (i=0; i<PTEST; i++){
		// 1printf ("La clase de la fila %d es %d \n",i,  (int) test[i][N1+1]);
		if (test[i][N1+1] > maxclass){
			maxclass = (int) test[i][N1+1];
			//printf("Encontramos una nueva clase! %d en data linea %d\n",(int)test[i][N1+1],i);
		}
	  }
  }
  NCLASES = maxclass;
  return 0;

}



/* ----------------------------------------------------------------------------------------------------- */

int create_files(char *filename, int class){
  FILE *fdata,*ftest,*fnet;
  
  /* Creamos el .data */
  sprintf(filepat,"%s.temp.data",filename);
  fdata=fopen(filepat,"w");
  error=(fdata==NULL);
  if(error){
    printf("Error creando el %s.temp.data \n",filename);
    return 1;
  }
  
  int i,k;

  /* Modificar sus clases a 0-1*/
  for(k=0; k < PTOT ; k++){
    for(i = 1 ;i<= N1;i++)  fprintf(fdata,"%f\t",data[k][i]);
    for(i = 0 ;i<=NCLASES; i++) fprintf(fdata,"%d\t", i==data[k][N1+1] ? 1 : 0);
    fprintf(fdata,"\n");
  }
  
  /* Creamos el .test */
  sprintf(filepat,"%s.temp.test",filename);
  ftest=fopen(filepat,"w");
  error=(ftest==NULL);
  if(error){
    printf("Error creando el %s.temp.test \n",filename);
    return 1;
  }

  /* Modificar sus clases a 0-1*/
  for(k=0; k < PTEST ; k++){
    for(i = 1 ;i<= N1;i++)  fprintf(ftest,"%f\t",test[k][i]);
    for(i = 0 ;i<=NCLASES; i++) fprintf(ftest,"%d\t", i==test[k][N1+1] ? 1 : 0);
    fprintf(ftest,"\n");
  }
  
  /* Creamos el .net */
  sprintf(filepat,"%s.temp.net",filename);
  fnet=fopen(filepat,"w");
  error=(fnet==NULL);
  if(error){
    printf("Error creando el %s.temp.net \n",filename);
    return 1;
  }

  /* Acomodando sus parámetros */
  fprintf(fnet,"%d\n",N1);
  fprintf(fnet,"%d\n",N2);
  fprintf(fnet,"%d\n",NCLASES+1);
  fprintf(fnet,"%d\n",PTOT);
  fprintf(fnet,"%d\n",PR);
  fprintf(fnet,"%d\n",PTEST);
  fprintf(fnet,"%d\n",ITER);
  fprintf(fnet,"%f\n",ETA);
  fprintf(fnet,"%f\n",u);
  fprintf(fnet,"%d\n",NERROR);
  fprintf(fnet,"%d\n",WTS);
  fprintf(fnet,"%d\n",SEED);
  fprintf(fnet,"%d",CONTROL);

  return 0;

}
/* ----------------------------------------------------------------------------------------------------- */
int main(int argc, char **argv){

  if(argc!=2){
    printf("Modo de uso: bp <filename> \ndonde filename es el nombre del archivo (sin extension)\n");
    return 0;
  }


  
  /* leo los datos del .net */
  error=arquitec(argv[1]);
  if(error){
    printf("Error en la definicion de la red\n");
    return 1;
  }
  
  /* leo los datos .data y .test , deduzco cuántas clases hay*/
  error=read_data(argv[1]);                 
  if(error){
    printf("Error en la lectura de datos\n");
    return 1;
  }
  printf("%d\n",NCLASES);

  /* creo los nuevos .data y .net para las proximas ejecuciones del bp común */

  int i;
  for (i=0; i<= NCLASES; i++){
	create_files(argv[1],i);
	if (error) {
		printf ("Error preparando los archivos para la clase %d\n",i);
		return 1;
	}
  }
  return 0;

}
/* ----------------------------------------------------------------------------------------------------- */












