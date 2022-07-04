%{
#include "cadenas_flex.h"
#include "elem.h"
#include "p6.tab.h"
/*" .|(){}[]<>/\+-*^?¿$@!&%~"'"*/
%}
VAR     [a-zA-Z_]+[a-zA-Z_0-9]*
TIPO    (int|float|bool|string|byte|short|long|double|char)
NUM [0-9]+
DEC [0-9]*"."[0-9]+
CAD \"[a-zA-Z_" .|(){}<>/\*^?¿$@!&%~,;""]+[a-zA-Z_" .|(){}<>/\*^?¿$@!&%~,;""]*\"
%%

{NUM}           {
                printf("\tNumero entero %s\n",yytext);
                yylval.entero = atoi(yytext);
                return (ENTERO);
                }

{DEC}           {
                printf("\tNumero decimal %s\n",yytext);
                yylval.decimal = atof(yytext);
                return (DECIMAL);
                }

{CAD}           {
                char *aux;
                aux=limpia(yytext);
                printf("\tCadena %s\n",aux);
                yylval.cadena = aux;
                return (CADENA);
                }

{TIPO}          {
                char *aux;
                aux=copia(yytext);
                printf("\tTipo %s\n",aux);
                yylval.cadena = aux;
                return (TIPO);
                }

[Mm][Oo][Dd]    {
                printf("\tModulo\n");
                return (MO);
                }

[Rr][Aa][Ii][Zz] {
                printf("\tRaiz\n");
                return (RAIZ);
                }

[Pp][Oo][Ww]    {
                printf("\tPotencia\n");
                return (POW);
                }

{VAR}           {
                char *aux;
                aux=copia(yytext);
                printf("\tVariable %s\n",aux);
                yylval.cadena = aux;
                return (VARIABLE);
                }

"+"	 	{
		printf("\tOperador mas\n");
                return (yytext[0]);
                }

"-"             {
                printf("\tOperador menos\n");
                return (yytext[0]);
                }

"*"             {
                printf("\tOperador multiplicar\n");
                return (yytext[0]);
                }

"/"             {
                printf("\tOperador division\n");
                return (yytext[0]);
                }

"%"             {
                printf("\tOperador modulo\n");
                return (yytext[0]);
                }

"="             {
                printf("\tOperador asignacion\n");
                return (yytext[0]);
                }

","             {
                printf("\tcoma\n");
                return (yytext[0]);
                }

"("            {
                printf("\tParentesis Izquierdo\n");
                return (yytext[0]);
                }

")"            {
                printf("\tParentesis Derecho\n");
                return (yytext[0]);
                }

";"             {
                printf("\tFin de expresion\n");
                return (yytext[0]);
                }
"["             {
                printf("\tCorchete izquierdo");
                return (yytext[0]);

                }               

"]"             {
                printf("\tCorchete derecho ");
                return (yytext[0]);
                
                }

"\n"            {
		printf("\tSalto de linea\n");
                return (yytext[0]);
                }

" "            {
                printf("\tEspacio\n");
                return (yytext[0]);
                }
.               ;
%%