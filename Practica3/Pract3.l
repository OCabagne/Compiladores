%{
#include "y.tab.h"
#include "cadenas_def.h"
#include <math.h>
%}

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



"MOD"           {
                printf("\tModulo\n");
                return (yytext[0]);
                }

"Raiz"          {
                printf("\tRaiz\n");
                return (yytext[0]);
                }

"pow"       {
                printf("\tPotencia\n");
                return (yytext[0]);
                }

"+"             {
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