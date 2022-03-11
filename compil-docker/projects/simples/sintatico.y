%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lexico.c"
#include "estrut.c"

void erro(char * s);
int yyerror(char *s);
int conta = 0;
int rotulo = 0;
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
                { 
                    mostra_tabela(); 
                    fprintf(yyout, "\tAMEM\t%d\n", conta);
                    empilha(conta);    
                }
        T_INICIO lista_comandos T_FIM
                {

                    fprintf(yyout, "\tDMEM\t%d\n", desempilha());       
                    fprintf(yyout, "\tFIMP\n");       
                }
        ;
    cabecalho
        : T_PROGRAMA T_IDENTIF
                { fprintf(yyout, "\tINPP\n");       }
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
        : lista_variaveis T_IDENTIF
            {
                strcpy(elem_tab.id, atomo);
                elem_tab.endereco = conta++;
                insere_simbolo(elem_tab);
            }
        | T_IDENTIF
            {
                strcpy(elem_tab.id, atomo);
                elem_tab.endereco = conta++;
                insere_simbolo(elem_tab);
            }
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
                { 
                    fprintf(yyout, "\tLEIA\n");
                    int pos = busca_simbolo(atomo);
                        if(pos == -1)
                            erro ("Variável não declarada!");       
                    fprintf(yyout, "\tARZG\t%d\n", TabSimb[pos].endereco);
                }
        ;
    escrita
        : T_ESCREVA expr
                { fprintf(yyout, "\tESCR\n");       }
        ;
    repeticao
        : T_ENQTO
                { 
                    rotulo++;
                    fprintf(yyout, "L%d\tNADA\n", rotulo);
                    empilha(rotulo);     
                } 
            expr T_FACA 
                { 
                    rotulo++;
                    fprintf(yyout, "\tDSVF\tL%d\n", rotulo);  
                    empilha(rotulo);
                }
            lista_comandos T_FIMENQTO
                { 
                    int r1 = desempilha();
                    int r2 = desempilha();
                    fprintf(yyout, "\tDSVS\tL%d\n", r2);   
                    fprintf(yyout, "L%d\tNADA\n", r1);     
                }
        ;
    repita
        : T_REPITA
            { 
                    rotulo++;
                    fprintf(yyout, "L%d\tNADA\n", rotulo);
                    empilha(rotulo);     
            }
        lista_comandos T_ATE
            { 
                    rotulo++;
                    fprintf(yyout, "\tDSVF\tL%d\n", rotulo);  
                    empilha(rotulo);
            }
        expr T_FIMREPITA
            { 
                    int r1 = desempilha();
                    int r2 = desempilha();
                    fprintf(yyout, "\tDSVS\tL%d\n", r2);   
                    fprintf(yyout, "L%d\tNADA\n", r1);     
            }
        ;
    selecao
        : T_SE expr T_ENTAO
                {   
                    rotulo++;
                    fprintf(yyout, "\tDSVF\tL%d\n", rotulo);   
                    empilha(rotulo);
                }
            lista_comandos T_SENAO
                { 
                    int r = desempilha();
                    rotulo++;
                    fprintf(yyout, "\tDSVS\tL%d\n", rotulo);   
                    empilha(rotulo);
                    fprintf(yyout, "L%d\tNADA\n", r);     
                }
            lista_comandos T_FIMSE
                { 
                    int r = desempilha();
                    fprintf(yyout, "L%d\tNADA\n", r);     
                }
        ;
    atribuicao
        : T_IDENTIF
            {    
                int pos = busca_simbolo(atomo);
                    if(pos == -1)
                        erro ("Variável não declarada!");       
                empilha(TabSimb[pos].endereco);
            }
            T_ATRIB expr
            {    
                int end = desempilha();
                fprintf(yyout, "\tARZG\t%d\n", end);
            }
        ;
    expr
        : expr T_VEZES expr
            { fprintf(yyout, "\tMULT\n");     }
        | expr T_DIV expr
            { fprintf(yyout, "\tDIVI\n");     }
        | expr T_MAIS expr
            { fprintf(yyout, "\tSOMA\n");     }
        | expr T_MENOS expr
            { fprintf(yyout, "\tSUBT\n");     }
        | expr T_MAIOR expr
            { fprintf(yyout, "\tCMMA\n");     }
        | expr T_MENOR expr
            { fprintf(yyout, "\tCMME\n");     }
        | expr T_IGUAL expr
            { fprintf(yyout, "\tCMIG\n");     }
        | expr T_E expr
            { fprintf(yyout, "\tCONJ\n");     }
        | expr T_OU expr
            { fprintf(yyout, "\tDISJ\n");     }
        | termo
        ;
    termo
        : T_IDENTIF
            { 
                int pos = busca_simbolo(atomo);
                    if(pos == -1)
                        erro ("Variável não declarada!");       
                fprintf(yyout, "\tCRVG\t%d\n", TabSimb[pos].endereco);     
            }
        | T_NUMERO
            { 
                fprintf(yyout, "\tCRCT\t%s\n", atomo);     
            }
        | T_V
            { fprintf(yyout, "\tDISJ\t1\n");     }
        | T_F
            { fprintf(yyout, "\tDISJ\t0\n");     }
        | T_NAO termo
            { fprintf(yyout, "\tNEGA\n");        }
        | T_ABRE expr T_FECHA
        ;

%%

void erro (char * s){
    fprintf(yyout, "ERRO: %s\n", s);
    
}

int yyerror (char *s){
    erro(s);
}

int main (int argc, char *argv[]){
    char *p, nameIn[100], nameOut[100];
    argv++;
    if(argc < 2){
        puts("\nCompilador Simples");
        puts("    USO: ./simples <nomefont>[.simples]\n\n");
        exit(10);
    }
    
    p = strstr(argv[0], ".simples");
    if(p) *p = 0;

    strcpy(nameIn, argv[0]);
    strcat(nameIn, ".simples");
    strcpy(nameOut, argv[0]);
    strcat(nameOut, ".mvs");

    yyin = fopen(nameIn, "rt");
    if(!yyin){
        puts("Programa fonte nao encontrado!");
        exit(10);
    }

    yyout = fopen(nameOut, "wt");

    if(!yyparse()){
        printf("Programa ok!\n");
    }
}