#include<stdlib.h>
#include<stdio.h>
int len_cad(char *cadena)
{
	int tam=0;
	while(cadena[tam]!='\0')
    {
        tam++;
    }return tam;
}

char *limpia(char *cadena)
{
	int i=1,j=0,tam;
	char *aux;
    tam=len_cad(cadena);
	aux=malloc(tam-1);
	while(i!=tam-1)
    {
    	aux[j]=cadena[i];
    	i++;
    	j++;
    }
    aux[tam-2]='\0';
    return aux;
}

char *copia(char *cadena1)
{
    int i=0,tam;
    char *cadena2;
    tam=len_cad(cadena1);
    cadena2=malloc(tam);
    while(i!=tam)
    {
        cadena2[i]=cadena1[i];
        i++;
    }
    cadena2[tam]='\0';
    return cadena2;
}