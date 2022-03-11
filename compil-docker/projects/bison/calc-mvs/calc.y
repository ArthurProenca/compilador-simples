%{
#include "lexico.c"
int valor[26];
%}

%token NUM
%token ENTER
%token MAIS
%token MENOS

%token ABRE
%token FECHA

%token BARRA
%token VEZES

%token VAR
%token RECEBE

%left MAIS MENOS
%left VEZES BARRA
%start linha

%%
linha   : linha comando ENTER
        |
        ;

comando: expr                   {  }
        | VAR RECEBE expr       { printf("\tARZG\t%d\n", $1);}
        ;

expr    : NUM                   { printf("\tCRCT\t%d\n", $1); }
        | VAR                   { printf("\tCRVG\t%d\n", $1); }
        | expr MAIS expr        { printf("\tSOMA\n"); }
        | expr MENOS expr       { printf("\tSUBT\n"); }
        | expr BARRA expr       { printf("\tDIVI\n"); }
        | expr VEZES expr       { printf("\tMULT\n"); }
        | ABRE expr FECHA       {  }
        ;

%%

void yyerror (char *s){
    printf("ERRO: %s", s);
    exit(10);
}

int main (void){
    yyparse();
}