identificador [a-zA-Z][a-zA-Z0-9]*
numero [0-9]+
espaco [ \t]+
novalinha [\n]

%x coment
%{
    int nlinha = 1;
%}

%%
programa          printf("%4d: Reservada: %s\n", nlinha, yytext);
fimprograma       printf("%4d: Reservada: %s\n", nlinha, yytext);
leia              printf("%4d: Reservada: %s\n", nlinha, yytext);
inicio            printf("%4d: Reservada: %s\n", nlinha, yytext);
escreva           printf("%4d: Reservada: %s\n", nlinha, yytext);
se                printf("%4d: Reservada: %s\n", nlinha, yytext);
entao             printf("%4d: Reservada: %s\n", nlinha, yytext);
senao             printf("%4d: Reservada: %s\n", nlinha, yytext);
fimse             printf("%4d: Reservada: %s\n", nlinha, yytext);
enquanto          printf("%4d: Reservada: %s\n", nlinha, yytext);
faca              printf("%4d: Reservada: %s\n", nlinha, yytext);
fimenquanto       printf("%4d: Reservada: %s\n", nlinha, yytext);

inteiro           printf("%4d: Tipos: %s\n", nlinha, yytext);
Logicos           printf("%4d: Tipos: %s\n", nlinha, yytext);

"+"               printf("%4d: Aritmetico: %s\n", nlinha, yytext);
"-"               printf("%4d: Aritmetico: %s\n", nlinha, yytext);
"*"               printf("%4d: Aritmetico: %s\n", nlinha, yytext);
div               printf("%4d: Aritmetico: %s\n", nlinha, yytext);

e                 printf("%4d: Logicos: %s\n", nlinha, yytext);
ou                printf("%4d: Logicos: %s\n", nlinha, yytext);
nao               printf("%4d: Logicos: %s\n", nlinha, yytext);

">"               printf("%4d: Relacional: %s\n", nlinha, yytext);
"<"               printf("%4d: Relacional: %s\n", nlinha, yytext);
"="               printf("%4d: Relacional: %s\n", nlinha, yytext);

"<-"              printf("%4d: Atribuicao: %s\n", nlinha, yytext);

V                 printf("%4d: Constante: %s\n", nlinha, yytext);
F                 printf("%4d: Constante: %s\n", nlinha, yytext);

{identificador}   printf("%4d: Identific.: %s\n", nlinha, yytext);
{numero}          printf("%4d: Numero: %s\n", nlinha, yytext);
{espaco}          ;
{novalinha}       nlinha++;
"//".*            ; /* nao faz nada */
"/*"              BEGIN(coment);
<coment>"*/"      BEGIN(INITIAL);
<coment>.         ; /* nao faz nada */
<coment>\n        nlinha++; 
.                 printf("ERRO LEX: %s\n", yytext);

%%

int yywrap(void){
    return 1;
}

int main(){
    yylex();
    return 0;
}