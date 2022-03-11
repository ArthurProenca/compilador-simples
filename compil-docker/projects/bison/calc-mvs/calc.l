%{
#include "calc.h"
#include <stdlib.h>
void yyerror(char *);  
%}

%%
[0-9]+  {yylval = atoi(yytext); return NUM; }
[A-Z]   {yylval = *yytext - 'A'; return VAR; }
[a-z]   {yylval = *yytext - 'A'; return VAR; }
"="     return RECEBE;
"+"     return MAIS;
"-"     return MENOS;
"("     return ABRE;
")"     return FECHA;
\n      return ENTER;
"*"     return VEZES;
"/"     return BARRA;
[ \t]+              ;
.       yyerror("Simbolo desconhecido!");
%%

int yywrap(void) {return 1;}

