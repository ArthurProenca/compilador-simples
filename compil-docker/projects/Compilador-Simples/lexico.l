%{
#include "sintatico.h"
void erro (char * s);
char atomo[100];
int nlinha = 1;
%}

identificador [a-zA-Z][a-zA-Z0-9]*
numero [0-9]+
espaco [ \t]+
novalinha [\n]

%option noyywrap

%x coment

%%
programa          return T_PROGRAMA;
fimprograma       return T_FIM;
leia              return T_LEIA;
inicio            return T_INICIO;
escreva           return T_ESCREVA;
se                return T_SE;
entao             return T_ENTAO;
senao             return T_SENAO;
fimse             return T_FIMSE;
enquanto          return T_ENQTO;
faca              return T_FACA;
fimenquanto       return T_FIMENQTO;

repita            return T_REPITA;
ate               return T_ATE;
fimrepita         return T_FIMREPITA;

inteiro           return T_INTEIRO;
logico            return T_LOGICO;
V                 return T_V;
F                 return T_F;

"+"               return T_MAIS;
"-"               return T_MENOS;
"*"               return T_VEZES;
div               return T_DIV;

e                 return T_E;
ou                return T_OU;
nao               return T_NAO;

">"               return T_MAIOR;
"<"               return T_MENOR;
"="               return T_IGUAL;

"<-"              return T_ATRIB;
"("               return T_ABRE;
")"               return T_FECHA;
"["               return T_INICIO_VETOR;
"]"               return T_FIM_VETOR;

{identificador}   { strcpy(atomo, yytext); return T_IDENTIF; }
{numero}          { strcpy(atomo, yytext); return T_NUMERO;  }
{espaco}          ;
{novalinha}       nlinha++;
"//".*            ; /* nao faz nada */
"/*"              BEGIN(coment);
<coment>"*/"      BEGIN(INITIAL);
<coment>.         ; /* nao faz nada */
<coment>\n        nlinha++; 
.                 erro ("ERRO LEX");

%%