%{
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "pcircular.h"

int yylex(void);

int yyerror (char *s)
{
  printf ("--%s--\n", s);
  return 0;
}
            
int yywrap()  
{
  return 1;  
}

Circular tabla=NULL;
Circular tabla_auxiliar=NULL;
int contador=0;
%}
           
/* Declaraciones de BISON */
%union
{
  int entero;
  double decimal;
  char *cadena;
  elem cosa;
}

%token <entero> ENTERO
%token <decimal> DECIMAL
%token <cadena> CADENA
%token <cadena> TIPO
%token <cosa> VARIABLE
%token <cadena> DECLARACION
%token <cadena> ERROR
%token <cadena> MO
%token <cadena> RAIZ
%token <cadena> POW
%type <decimal> expd
%type <entero> exp
%type <cadena> expc
%type <cadena> expt
%type <cosa> expv
%type <cadena> expdec
%type <cadena> exp_error


%left '+' '-'
%left '*' '/' '^'
%right M R
             
/* Gramática */
%%
             
input:    /* cadena vacía */
  | input line             
;

line:     '\n'
  | exp '\n'  { printf ("\t\tresultado: %d\n", $1); }
    | expd '\n'  { printf ("\t\tresultado: %f\n", $1); }
  | expc '\n'  { printf ("\t\tresultado: %s\n", $1); }
    | expt '\n'  { printf ("\t\tresultado: %s\n", $1); }
    | expv '\n'  { impcosa($1);}
    | expdec '\n'  { }
    | exp_error '\n'  { }
;
            
exp:     ENTERO { $$ = $1; }
  | exp '+' exp        { $$ = $1 + $3;    }
  | '-' exp            { $$ = -$2;    }
  | '+' exp            { $$ = $2;    }  
  | exp '-' exp        { $$ = $1 - $3;    }
  | exp '*' exp        { $$ = $1 * $3;    }
  | exp '/' exp        { $$ = $1 / $3;    }
  | POW '(' exp ',' exp ')' { $$ = pow($3,$5); }
  | MO '(' exp ',' exp ')' {$$ = $3 % $5;    }
;

expd:     DECIMAL { $$ = $1; }
  | '-' expd            { $$ = -$2;    }
  | '+' expd            { $$ = $2;    }
  | expd '+' expd        { $$ = $1 + $3;    }
  | expd '-' expd        { $$ = $1 - $3;    }
  | expd '*' expd        { $$ = $1 * $3;    }
  | expd '/' expd        { $$ = $1 / $3;    }
  | POW '(' expd ',' expd ')' { $$ = pow($3,$5); }
  | exp '+' expd        { $$ = $1 + $3;    }
  | exp '-' expd        { $$ = $1 - $3;    }
  | exp '*' expd        { $$ = $1 * $3;    }
  | exp '/' expd        { $$ = $1 / $3;    }
  | POW '(' exp ',' expd ')' { $$ = pow($3,$5); }
  | expd '+' exp        { $$ = $1 + $3;    }
  | expd '-' exp        { $$ = $1 - $3;    }
  | expd '*' exp        { $$ = $1 * $3;    }
  | expd '/' exp        { $$ = $1 / $3;    }
  | POW '(' expd ',' exp ')' { $$ = pow($3,$5); }
  | MO '(' expd ',' expd ')' {$$ = fmod($3,$5);    }
  | RAIZ '(' exp ')'   {$$ = sqrt($3);    }
  | RAIZ '(' expd ')'   {$$ = sqrt($3);    }
;

expc:     CADENA { $$ = $1; }
  | expc '+' expc        
    {
        char *aux;
        aux=suma($1,$3);
        $$ = aux;    
    }
    | expc '-' expc        
  {
    char *aux;
    aux=resta($1,$3);
    $$ = aux;
    }
  | POW '(' expc ',' exp ')' 
  {
    char *aux;
    aux=potencia($3,$5);
    $$=aux;
  }

expt:       TIPO { $$ = $1; }

expv:       VARIABLE { $$ = $1; }
  | expv '+' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1 && estaen($3,tabla)==1)
    {
      $1=busca($1,tabla);
      $3=busca($3,tabla);

      if (compara($1.tipo,"string")==1 && compara($3.tipo,"string")==1)
      {
        aux.dato.cadena=suma($1.dato.cadena,$3.dato.cadena);
        aux.tipo="string";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"int")==1)
      {
        aux.dato.entero=$1.dato.entero+$3.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1.dato.entero+$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"int")==1)
      {
        aux.dato.flotante=$1.dato.flotante+$3.dato.entero;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1.dato.flotante+$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf(" Error: conflicto de tipos !\n");
      }
    }
    else if (estaen($1,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
      else if(estaen($3,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }

  | exp '+' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos !\n");
      }
      else if (compara($3.tipo,"int")==1)
      {
        aux.dato.entero=$1+$3.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1+$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }

  | expv '+' exp        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos !\n");
      }
      else if (compara($1.tipo,"int")==1)
      {
        aux.dato.entero=$3+$1.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1)
      {
        aux.dato.flotante=$3+$1.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
  }

  | expd '+' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos !\n");
      }
      else if (compara($3.tipo,"int")==1)
      {
        aux.dato.flotante=$1+$3.dato.entero;
        aux.tipo="double";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1+$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf(" Error %s no se ha declarado !\n",$3.nombre);
    }
  }

  | expv '+' expd        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos !\n");
      }
      else if (compara($1.tipo,"int")==1)
      {
        aux.dato.flotante=$3+$1.dato.entero;
        aux.tipo="double";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1)
      {
        aux.dato.flotante=$3+$1.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
  }
  | expc '+' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        aux.dato.cadena=suma($1,$3.dato.cadena);
        aux.tipo="string";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else
    {
      printf("Error %s no se ha declarado!\n",$3.nombre);
    }
  }

  | expv '+' expc        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        aux.dato.cadena=suma($1.dato.cadena,$3);
        aux.tipo="string";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else
    {
      printf(" Error %s no se ha declarado !\n",$1.nombre);
    }
  }
  | expv '-' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1 && estaen($3,tabla)==1)
    {
      $1=busca($1,tabla);
      $3=busca($3,tabla);

      if (compara($1.tipo,"string")==1 && compara($3.tipo,"string")==1)
      {
        aux.dato.cadena=suma($1.dato.cadena,$3.dato.cadena);
        aux.tipo="string";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"int")==1)
      {
        aux.dato.entero=$1.dato.entero-$3.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1.dato.entero-$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"int")==1)
      {
        aux.dato.flotante=$1.dato.flotante-$3.dato.entero;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1.dato.flotante-$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else if (estaen($1,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
      else if(estaen($3,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | exp '-' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf(" Error: conflicto de tipos !\n");
      }
      else if (compara($3.tipo,"int")==1)
      {
        aux.dato.entero=$1-$3.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1-$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | expv '-' exp        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos !\n");
      }
      else if (compara($1.tipo,"int")==1)
      {
        aux.dato.entero=$3-$1.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1)
      {
        aux.dato.flotante=$3-$1.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
  }
  | expd '-' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos !\n");
      }
      else if (compara($3.tipo,"int")==1)
      {
        aux.dato.flotante=$1-$3.dato.entero;
        aux.tipo="double";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1-$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | expv '-' expd        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos !\n");
      }
      else if (compara($1.tipo,"int")==1)
      {
        aux.dato.flotante=$3-$1.dato.entero;
        aux.tipo="double";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1)
      {
        aux.dato.flotante=$3-$1.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado!\n",$1.nombre);
    }
  }
  | expc '-' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        aux.dato.cadena=suma($1,$3.dato.cadena);
        aux.tipo="string";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | expv '-' expc        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        aux.dato.cadena=suma($1.dato.cadena,$3);
        aux.tipo="string";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
  }

  | expv '*' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1 && estaen($3,tabla)==1)
    {
      $1=busca($1,tabla);
      $3=busca($3,tabla);

      if (compara($1.tipo,"string")==1 && compara($3.tipo,"string")==1)
      {
        printf(":/ Error operacion no disponible \n");
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"int")==1)
      {
        aux.dato.entero=$1.dato.entero*$3.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1.dato.entero*$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"int")==1)
      {
        aux.dato.flotante=$1.dato.flotante*$3.dato.entero;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1.dato.flotante*$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else if (estaen($1,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
      else if(estaen($3,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | exp '*' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf("!!!! Error: conflicto de tipos!\n");
      }
      else if (compara($3.tipo,"int")==1)
      {
        aux.dato.entero=$1*$3.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1*$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado!\n",$3.nombre);
    }
  }
  | expv '*' exp        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos!\n");
      }
      else if (compara($1.tipo,"int")==1)
      {
        aux.dato.entero=$3*$1.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1)
      {
        aux.dato.flotante=$3*$1.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado!\n",$1.nombre);
    }
  }
  | expd '*' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos!\n");
      }
      else if (compara($3.tipo,"int")==1)
      {
        aux.dato.flotante=$1*$3.dato.entero;
        aux.tipo="double";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1*$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | expv '*' expd        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos!\n");
      }
      else if (compara($1.tipo,"int")==1)
      {
        aux.dato.flotante=$3*$1.dato.entero;
        aux.tipo="double";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1)
      {
        aux.dato.flotante=$3*$1.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
  }
  | expc '*' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        aux.dato.cadena=suma($1,$3.dato.cadena);
        aux.tipo="string";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos!\n");
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | expv '*' expc        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        aux.dato.cadena=suma($1.dato.cadena,$3);
        aux.tipo="string";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
  }

  | expv '/' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1 && estaen($3,tabla)==1)
    {
      $1=busca($1,tabla);
      $3=busca($3,tabla);

      if (compara($1.tipo,"string")==1 && compara($3.tipo,"string")==1)
      {
        printf(":/ Error operacion no disponible \n");
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"int")==1)
      {
        aux.dato.entero=$1.dato.entero/$3.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1.dato.entero/$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"int")==1)
      {
        aux.dato.flotante=$1.dato.flotante/$3.dato.entero;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1.dato.flotante/$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else
      {
        printf("Error: conflicto de tipos!\n");
      }
    }
    else if (estaen($1,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
      else if(estaen($3,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | exp '/' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos!\n");
      }
      else if (compara($3.tipo,"int")==1)
      {
        aux.dato.entero=$1/$3.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1/$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado!\n",$3.nombre);
    }
  }
  | expv '/' exp        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos!\n");
      }
      else if (compara($1.tipo,"int")==1)
      {
        aux.dato.entero=$3/$1.dato.entero;
        aux.tipo="int";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1)
      {
        aux.dato.flotante=$3/$1.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado!\n",$1.nombre);
    }
  }
  | expd '/' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos!\n");
      }
      else if (compara($3.tipo,"int")==1)
      {
        aux.dato.flotante=$1/$3.dato.entero;
        aux.tipo="double";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($3.tipo,"double")==1)
      {
        aux.dato.flotante=$1/$3.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | expv '/' expd        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf("Error: conflicto de tipos!\n");
      }
      else if (compara($1.tipo,"int")==1)
      {
        aux.dato.flotante=$3/$1.dato.entero;
        aux.tipo="double";
        aux.nombre=suma("nombre",numero);
        tabla=formar(aux,tabla);
        $$=aux;
      }
      else if (compara($1.tipo,"double")==1)
      {
        aux.dato.flotante=$3/$1.dato.flotante;
        aux.tipo="double";
        tabla=formar(aux,tabla);
        $$=aux;
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
  }
  | expc '/' expv        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($3,tabla)==1)
    {
      $3=busca($3,tabla);
      if (compara($3.tipo,"string")==1)
      {
        printf(":/ Error operacion no disponible \n");
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }
  | expv '/' expc        
  {
    elem aux;
    contador++;
    char numero[10];
    itoa(contador,numero,10);
    if (estaen($1,tabla)==1)
    {
      $1=busca($1,tabla);
      if (compara($1.tipo,"string")==1)
      {
        printf(":/ Error operacion no disponible \n");
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
  }

expdec:     DECLARACION { $$ = $1; }
  | expt ' ' expv ';'  
    {
      elem token;
      token.nombre=$3.nombre;
      token.tipo=$1;
        if (estaen(token,tabla)==1)
        {
          printf("Error %s ya existe !\n",token.nombre);
        }
        else if (estaen(token,tabla)==0)
        {
            if (compara(token.tipo,"int")==1)
            {
              token.dato.entero=0;
            }
            else if (compara(token.tipo,"double")==1)
            {
              token.dato.flotante=0.0;
            }
            else if (compara(token.tipo,"string")==1)
            {
              token.dato.cadena="vacio";
            }
            tabla=formar(token,tabla);
            printf("** Se ha agregado %s\n",token.nombre);
            impcir(tabla);
        }
    }
    | expt ' ' expv '=' exp ';'
    {
      elem token;
      token.nombre=copy($3.nombre);
        token.tipo=$1;
        if (estaen(token,tabla)==1)
        {
          printf("Error %s ya existe !\n",token.nombre);
        }
        else if (estaen(token,tabla)==0)
        {
            if (compara(token.tipo,"int")==1)
            {
              token.dato.entero=$5;
              tabla=formar(token,tabla);
              printf ("\t\tresultado: %d\n", token.dato.entero);
              printf("** Se ha agregado %s\n",token.nombre);
              impcir(tabla);
            }
            else if (compara(token.tipo,"double")==1)
            {
                token.dato.flotante=$5;
                tabla=formar(token,tabla);
                printf ("\t\tresultado: %f\n", token.dato.flotante);
                printf("** Se ha agregado %s\n",token.nombre);
                impcir(tabla);
            }
            else
            {
                printf("Error: conflicto de tipos se esperaba %s !\n",token.tipo);
            }
        }
    }
    | expt ' ' expv '=' expd ';'
    {
        elem token;
        token.nombre=copy($3.nombre);
        token.tipo=$1;
        if (estaen(token,tabla)==1)
        {
            printf(" Error %s ya existe !\n",token.nombre);
        }
        else if (estaen(token,tabla)==0)
        {
            if (compara(token.tipo,"int")==1)
            {
              token.dato.entero=$5;
              tabla=formar(token,tabla);
              printf ("\t\tresultado: %d\n", token.dato.entero);
              printf("** Se ha agregado %s\n",token.nombre);
              impcir(tabla);
            }
            else if (compara(token.tipo,"double")==1)
            {
                token.dato.flotante=$5;
                tabla=formar(token,tabla);
                printf ("\t\tresultado: %f\n", token.dato.flotante);
                printf("** Se ha agregado %s\n",token.nombre);
                impcir(tabla);
            }
            else
            {
                printf("!!!! Error: conflicto de tipos se esperaba %s !\n",token.tipo);
            }
        }
    }
    | expt ' ' expv '=' expc ';'
    {
        elem token;
        token.nombre=copy($3.nombre);
        token.tipo=$1;
        if (estaen(token,tabla)==1)
        {
            printf("Error %s ya existe !\n",token.nombre);
        }
        else if (estaen(token,tabla)==0)
        {
            if (compara(token.tipo,"string")==1)
            {
                token.dato.cadena=$5;
                tabla=formar(token,tabla);
                printf ("\t\tresultado: %s\n", token.dato.cadena);
                printf("** Se ha agregado %s\n",token.nombre);
                impcir(tabla);
            }
            else
            {
                printf("Error: conflicto de tipos se esperaba %s !\n",token.tipo);
            }
        }
    }
    | expv '=' exp ';'
    {
        elem token,aux;
        token.nombre=copy($1.nombre);
        if (estaen(token,tabla)==1)
        {
            aux=busca(token,tabla);
            if (compara(aux.tipo,"int")==1)
            {
                aux.dato.entero=$3;
                printf ("\t\tresultado: %d\n", aux.dato.entero);
                reemplaza(aux,tabla);
                impcir(tabla);
            }
            else if (compara(aux.tipo,"double")==1)
            {
                aux.dato.flotante=$3;
                printf ("\t\tresultado: %f\n", aux.dato.flotante);
                reemplaza(aux,tabla);
                impcir(tabla);
            }
            else
            {
                printf("Error: conflicto de tipos se esperaba %s \n",aux.tipo);
            }
        }
        else if (estaen(token,tabla)==0)
        {
            printf("Error %s no se ha declarado !\n",token.nombre);
        }
    }
    | expv '=' expd ';'
    {
        elem token,aux;
        token.nombre=copy($1.nombre);
        if (estaen(token,tabla)==1)
        {
            aux=busca(token,tabla);
            if (compara(aux.tipo,"int")==1)
            {
                aux.dato.entero=$3;
                reemplaza(aux,tabla);
                printf ("\t\tresultado: %d\n", aux.dato.entero);
                impcir(tabla);
            }
            else if (compara(aux.tipo,"double")==1)
            {
                aux.dato.flotante=$3;
                reemplaza(aux,tabla);
                printf ("\t\tresultado: %f\n", aux.dato.flotante);
                impcir(tabla);
            }
        }
        else if (estaen(token,tabla)==0)
        {
            printf(" Error %s no se ha declarado !\n",token.nombre);
        }
    }
    | expv '=' expc ';'
    {
        elem token,aux;
        token.nombre=copy($1.nombre);
        if (estaen(token,tabla)==1)
        {
            aux=busca(token,tabla);
            if (compara(aux.tipo,"string")==1)
            {
                aux.dato.cadena=$3;
                reemplaza(aux,tabla);
                printf ("\t\tresultado: %s\n", aux.dato.cadena);
                impcir(tabla);
            }
            else
            {
                printf("Error: conflicto de tipos se esperaba %s !\n",aux.tipo);
            }
        }
        else if (estaen(token,tabla)==0)
        {
            printf("Error %s no se ha declarado !\n",token.nombre);
        }
    }
    | expt ' ' expv '=' expv ';'
    {
      $3.tipo=copy($1);
    if (estaen($5,tabla)==1)
    {
      $5=busca($5,tabla);
      if (compara($3.tipo,"string")==1 && compara($5.tipo,"string")==1)
      {
        $3.dato.cadena=$5.dato.cadena;
        $3.tipo="string";
        tabla=formar($3,tabla);
        printf("** Se ha agregado %s\n",$3.nombre);
        impcir(tabla);
      }
      else if (compara($3.tipo,"int")==1 && compara($5.tipo,"int")==1)
      {
        $3.dato.entero=$5.dato.entero;
        $3.tipo="int";
        tabla=formar($3,tabla);
        printf("** Se ha agregado %s\n",$3.nombre);
        impcir(tabla);
      }
      else if (compara($3.tipo,"int")==1 && compara($5.tipo,"double")==1)
      {
        $3.dato.entero=$5.dato.flotante;
        $3.tipo="int";
        tabla=formar($3,tabla);
        printf("** Se ha agregado %s\n",$3.nombre);
        impcir(tabla);
      }
      else if (compara($3.tipo,"double")==1 && compara($5.tipo,"int")==1)
      {
        $3.dato.flotante=$5.dato.entero;
        $3.tipo="double";
        tabla=formar($3,tabla);
        printf("** Se ha agregado %s\n",$3.nombre);
        impcir(tabla);
      }
      else if (compara($3.tipo,"double")==1 && compara($5.tipo,"double")==1)
      {
        $3.dato.flotante=$5.dato.flotante;
        $3.tipo="double";
        tabla=formar($3,tabla);
        printf("** Se ha agregado %s\n",$3.nombre);
        impcir(tabla);
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else if (estaen($3,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
      else if(estaen($5,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$5.nombre);
    }
  }
  //modificacion
  //
  | expt ' ' expv'[' exp ']' ';'
  {
      int n;
      elem token;
      char* aux;

      
      //token=malloc($5*sizeof(elem));
      //if (token==NULL) exit(1);

      for (n=0;n<$5;n++){
      //strcpy(aux,(char*)n);
      token.nombre=$3.nombre;
      //strcat(token.nombre,aux);
      strcat(token.nombre, "[");
      //strcat(token[n].nombre, aux);
      //strcat(token[n].nombre, "]");
      token.tipo=$1;
      
        if (estaen(token,tabla)==1)
        {
          printf("Error %s ya existe !\n",token.nombre);
        }
        else if (estaen(token,tabla)==0)
        {
            if (compara(token.tipo,"int")==1)
            {
              token.dato.entero=0;
            }
            else if (compara(token.tipo,"double")==1)
            {
              token.dato.flotante=0.0;
            }
            else if (compara(token.tipo,"string")==1)
            {
              token.dato.cadena="vacio";
            }
            
            tabla=formar(token,tabla);
            printf("** Se ha agregado %s\n",token.nombre);
            }
            impcir(tabla);
            }
  }
  
  | expv'[' exp ']' '=' expv ';'
  {
  
  }
  
  
  | expv '=' expv ';'
    {
    if (estaen($1,tabla)==1 && estaen($3,tabla)==1)
    {
      $1=busca($1,tabla);
      $3=busca($3,tabla);
      $1.nombre=copy($1.nombre);
      $3.nombre=copy($3.nombre);
      if (compara($1.tipo,"string")==1 && compara($3.tipo,"string")==1)
      {
        $1.dato.cadena=$3.dato.cadena;
        reemplaza($1,tabla);
        printf("** Se ha modificado %s\n",$1.nombre);
        impcir(tabla);
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"int")==1)
      {
        $1.dato.entero=$3.dato.entero;
        reemplaza($1,tabla);
        printf("** Se ha modificado %s\n",$1.nombre);
        impcir(tabla);
      }
      else if (compara($1.tipo,"int")==1 && compara($3.tipo,"double")==1)
      {
        $1.dato.entero=$3.dato.flotante;
        reemplaza($1,tabla);
        printf("** Se ha modificado %s\n",$1.nombre);
        impcir(tabla);
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"int")==1)
      {
        $1.dato.flotante=$3.dato.entero;
        reemplaza($1,tabla);
        printf("** Se ha modificado %s\n",$1.nombre);
        impcir(tabla);
      }
      else if (compara($1.tipo,"double")==1 && compara($3.tipo,"double")==1)
      {
        $1.dato.flotante=$3.dato.flotante;
        reemplaza($1,tabla);
        printf("** Se ha modificado %s\n",$1.nombre);
        impcir(tabla);
      }
      else
      {
        printf("Error: conflicto de tipos !\n");
      }
    }
    else if (estaen($1,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$1.nombre);
    }
      else if(estaen($3,tabla)==0)
    {
      printf("Error %s no se ha declarado !\n",$3.nombre);
    }
  }

exp_error:     ERROR { $$ = $1; }
  | expt ' ' expv
    {
      printf("Error: se esperaba ; \n");
    }
  | expt ' ' expv '=' exp
    {
      printf("Error: No se esperaba ;\n");
    }
  | expt ' ' expv '=' expd
    {
      printf("Error: se esperaba ; \n");
    }
  | expt ' ' expv '=' expc
    {
      printf("Error: se esperaba ; \n");
    }
  | expt ' ' expv ','
    {
      printf("Error:  se esperaba ; !\n");
    }
  | expt ' ' expv '=' exp ','
    {
      printf("Error:  se esperaba ; !\n");
    }
  | expt ' ' expv '=' expd ','
    {
      printf("Error:  se esperaba ; \n");
    }
  | expt ' ' expv '=' expc ','
    {
      printf("Error:  se esperaba ; \n");
    }
;
%%

int main() 
{
  yyparse();
  return 0;
}