%{
#include <stdio.h>
#include <stdlib.h>
#include "lexico.c"

void erro(char * s);
int yyerror(char *s);
%}

%start programa

%token T_PROGRAMA
%token T_FIM
%token T_LEIA
%token T_INICIO
%token T_ESCREVA
%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE
%token T_ENQTO
%token T_FIMENQTO
%token T_FACA

%token T_REPITA
%token T_ATE
%token T_FIMREPITA

%token T_INTEIRO
%token T_LOGICO
%token T_V
%token T_F
 
%token T_MAIS
%token T_MENOS
%token T_VEZES

%token T_E
%token T_OU
%token T_NAO

%token T_MAIOR
%token T_MENOR

%token T_ATRIB
%token T_ABRE
%token T_FECHA

%token T_IDENTIF
%token T_NUMERO

%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%
    programa
        : cabecalho variaveis 
                { printf("\tAMEM\tx\n");       }
        T_INICIO lista_comandos T_FIM
                { printf("\tDMEM\tx\n");       }
                { printf("\tFIMP\tx\n");       }
        ;
    cabecalho
        : T_PROGRAMA T_IDENTIF
                { printf("\tINPP\n");       }
        ;
    variaveis
        :
        | declaracao_variaveis
        ;
    declaracao_variaveis
        : tipo lista_variaveis declaracao_variaveis
        | tipo lista_variaveis
        ;
    tipo
        : T_INTEIRO
        | T_LOGICO
        ;
    lista_variaveis
        : T_IDENTIF lista_variaveis
        | T_IDENTIF
        ;
    lista_comandos
        :
        | comando lista_comandos
        ;
    comando
        : leitura
        | escrita
        | repita
        | repeticao
        | selecao
        | atribuicao
        ;
    leitura
        : T_LEIA T_IDENTIF
                { printf("\tLEIA\n");       }
                { printf("\tARZG\tx\n");    }
        ;
    escrita
        : T_ESCREVA expr
                { printf("\tESCR\n");       }
        ;
    repeticao
        : T_ENQTO
                { printf("Lx\tNADA\n");     } 
            expr T_FACA 
                { printf("\tDSVF\tLy\n");    }
            lista_comandos T_FIMENQTO
                { printf("\tDSVS\tLx\n");   }
                { printf("Ly\tNADA\n");     }
        ;
    repita
        : T_REPITA lista_comandos T_ATE expr T_FIMREPITA
        ;
    selecao
        : T_SE expr T_ENTAO
                { printf("\tDSVF\tLx\n");   }
            lista_comandos T_SENAO
                { printf("\tDSVS\tLy\n");   }
                { printf("Lx\tNADA\n");     }
            lista_comandos T_FIMSE
                { printf("Ly\tNADA\n");     }
        ;
    atribuicao
        : T_IDENTIF T_ATRIB expr
            { printf("\tARZG\tx\n");    }
        ;
    expr
        : expr T_VEZES expr
            { printf("\tMULT\n");     }
        | expr T_DIV expr
            { printf("\tDIVI\n");     }
        | expr T_MAIS expr
            { printf("\tSOMA\n");     }
        | expr T_MENOS expr
            { printf("\tSUBT\n");     }
        | expr T_MAIOR expr
            { printf("\tCMMA\n");     }
        | expr T_MENOR expr
            { printf("\tCMME\n");     }
        | expr T_IGUAL expr
            { printf("\tCMIG\n");     }
        | expr T_E expr
            { printf("\tCONJ\n");     }
        | expr T_OU expr
            { printf("\tDISJ\n");     }
        | termo
        ;
    termo
        : T_IDENTIF
            { printf("\tCRVG\tx\n");     }
        | T_NUMERO
            { printf("\tCRCT\tx\n");     }
        | T_V
            { printf("\tDISJ\t1\n");     }
        | T_F
            { printf("\tDISJ\t0\n");     }
        | T_NAO termo
            { printf("\tNEGA\n");        }
        | T_ABRE expr T_FECHA
        ;

%%

void erro (char * s){
    printf("ERRO: %s\n", s);
    
}

int yyerror (char *s){
    erro(s);
}

int main (void){
    if(!yyparse()){
        printf("Programa ok!\n");
    }
}