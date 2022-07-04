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

char *suma(char *cadena1,char *cadena2)
{
    int i=0,j=0,t1,t2;
    char *aux;
    t1=len_cad(cadena1);
    t2=len_cad(cadena2);
    aux=malloc(t1+t2);
    while(cadena1[i]!='\0')
    {
        aux[j]=cadena1[i];
        i++;
        j++;
    }i=0;
    while(cadena2[i]!='\0')
    {
        aux[j]=cadena2[i];
        i++;
        j++;
    }aux[t1+t2]='\0';
    return aux;
}

char *resta(char *cadena1,char *cadena2)
{
    int i=0,j=0,t1,t2,c=0;
    char *aux;
    t1=len_cad(cadena1);
    t2=len_cad(cadena2);
    aux=malloc(t1+t2);
    while(cadena1[i]!='\0')
    {
        if(cadena1[i]==cadena2[j])
        {
            i++;
            j++;
        }
        else
        {
            aux[c]=cadena1[i];
            i++;
            c++;
        }
    }
    if(j!=t2)
    {
        aux = cadena1;
    }
    aux[c]='\0';
    return aux;
}

char *potencia(char *cadena1,int n)
{
    int i=0,j=0,t1,k=0;
    char *aux;
    t1=len_cad(cadena1);
    aux=malloc(t1*n);
    for(k=0;k<n;k++)
    {
        while(cadena1[i]!='\0')
        {
            aux[j]=cadena1[i];
            i++;
            j++;
        }i=0;
    }
    aux[t1*n]='\0';
    return aux;
}

char *prefijo(char *cadena1,int n)
{
    int i=0,j=0,t1,k=0;
    char *aux;
    t1=len_cad(cadena1);
    aux=malloc(n);
    if(n>t1 || n<0)
    {
        printf("ERRORRRRRRRRRRRR\n");
        aux="vacia";
    }
    else if(n==t1)
    {
        aux=cadena1;
    }
    else if(n==0)
    {
        printf("ERRORRRRRRRRRRRR\n");
        aux="vacia";
    }
    else
    {
        for(k=0;k<n;k++)
        {
            aux[k]=cadena1[k];
        }aux[n]='\0';
    }
    return aux;
}                

int compara(char *cadena1,char *cadena2)
{
    int i=0,j=0;
    while(cadena1[i]!='\0')
    {
        if (cadena1[i]==cadena2[i])
        {
            j++;
        }i++;
    }
    if (i==j)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}