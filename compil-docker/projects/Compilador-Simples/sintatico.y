%{
/*+--------------------------------------------------------------------
  |             UNIFAL − Universidade Federal de Alfenas
  |              Bacharelado em Ciência da Computação
  |  Trabalho..: Vetor e verificação de tipos
  |  Disciplina: Teoria de Linguagens e Compiladores
  |  Professor.: Luiz Eduardo da Silva
  |  Aluno.....: Arthur Rodrigues Proença
  |  Data......: 06/04/2022
  +----------------------------------------------------------------------*/
%}
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lexico.c"
#include "estrut.c"

void erro(char * s);
int yyerror(char *s);
int conta = 0;
int vetor = 0;
int rotulo = 0;
char tipo;
int tamanho;
char categoria;
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

%token T_INICIO_VETOR
%token T_FIM_VETOR

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
        : T_INTEIRO { tipo = 'i', tamanho = 1, categoria = 'v';}
        | T_LOGICO  { tipo = 'l', tamanho = 1, categoria = 'v';}
        ;
    lista_variaveis
        : lista_variaveis variavel
        | variavel
        ;

    variavel
        :  T_IDENTIF 
            { 
                strcpy(elem_tab.id, atomo);
            }
            tamanho
        ;
    tamanho
        :
            {
                elem_tab.endereco = conta;
                conta += tamanho;
                elem_tab.tipo = tipo;
                elem_tab.tamanho = tamanho;
                elem_tab.cat = categoria;
                insere_simbolo(elem_tab);
            }
        | T_INICIO_VETOR T_NUMERO
            {
                
                elem_tab.endereco = conta;
                conta +=atoi(atomo);
                elem_tab.tipo = tipo;
                elem_tab.tamanho =  atoi(atomo);
                elem_tab.cat = 'a';
                insere_simbolo(elem_tab);
            } 
        T_FIM_VETOR
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
                
                int pos = busca_simbolo(atomo);
                    if(pos == -1)
                        erro ("Variável não declarada!");
                empilha(pos);
                
            } posicao
        ;

    escrita
        : T_ESCREVA expr
            { 
               desempilha();
               fprintf(yyout, "\tESCR\n");       
            }
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
                char t = desempilha();
                if(t != 'l')
                    erro("Incompatibilidade de tipos!");
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
                char t = desempilha();
                if(t != 'l')
                    erro("Incompatibilidade de tipos!");
                int r1 = desempilha();
                int r2 = desempilha();
                fprintf(yyout, "\tDSVS\tL%d\n", r2);   
                fprintf(yyout, "L%d\tNADA\n", r1);     
            }
        ;
    selecao
        : T_SE expr T_ENTAO
            {   
                char t = desempilha();
                if(t != 'l')
                    erro("Incompatibilidade de tipos!");
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
                empilha(pos);
            }
            posicaoAux T_ATRIB expr
            {    
                char t = desempilha();
                int p = desempilha();
                
                if(t != TabSimb[p].tipo)
                    erro("Incompatibilidade de tipos!");

                
                if(TabSimb[p].cat == 97) {   
                                 
                    fprintf(yyout, "\tARZV\t%d\n", TabSimb[p].endereco);
                } else {
                    fprintf(yyout, "\tARZG\t%d\n", TabSimb[p].endereco);
                }
            }          
        ;

    expr
        : expr T_VEZES expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'i' || t2 != 'i')
                    erro("Incompatibilidade de tipos!");
                empilha('i');
                fprintf(yyout, "\tMULT\n");   
            }
        | expr T_DIV expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'i' || t2 != 'i')
                    erro("Incompatibilidade de tipos!");
                empilha('i');
                fprintf(yyout, "\tDIVI\n");     
            }
        | expr T_MAIS expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'i' || t2 != 'i')
                    erro("Incompatibilidade de tipos!");
                empilha('i');
                fprintf(yyout, "\tSOMA\n");
             }
        | expr T_MENOS expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'i' || t2 != 'i')
                    erro("Incompatibilidade de tipos!");
                empilha('i');
                fprintf(yyout, "\tSUBT\n");     
            }
        | expr T_MAIOR expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'i' || t2 != 'i')
                    erro("Incompatibilidade de tipos!");
                empilha('l');
                fprintf(yyout, "\tCMMA\n");     
            }
        | expr T_MENOR expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'i' || t2 != 'i')
                    erro("Incompatibilidade de tipos!");
                empilha('l');
                fprintf(yyout, "\tCMME\n");     
            }
        | expr T_IGUAL expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'i' || t2 != 'i')
                    erro("Incompatibilidade de tipos!");
                empilha('l');
                fprintf(yyout, "\tCMIG\n");     
            }
        | expr T_E expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'l' || t2 != 'l')
                    erro("Incompatibilidade de tipos!");
                empilha('l');
                fprintf(yyout, "\tCONJ\n");     
            }
        | expr T_OU expr
            { 
                char t1 = desempilha();
                char t2 = desempilha();
                if(t1 != 'l' || t2 != 'l')
                    erro("Incompatibilidade de tipos!");
                empilha('l');
                fprintf(yyout, "\tDISJ\n");     
            }
        | termo
        ;
    indice
        :   
            {
                int id = desempilha();
                fprintf(yyout, "\tCRVG\t%d\n", TabSimb[id].endereco);
            }
        | T_INICIO_VETOR expr
            {         
                desempilha();
                int id =  desempilha();
                fprintf(yyout, "\tCRVV\t%d\n", TabSimb[id].endereco);
            } T_FIM_VETOR
        ;
    posicao
        : 
            {
                int pos = desempilha();
                fprintf(yyout, "\tLEIA\n");
                fprintf(yyout, "\tARZG\t%d\n", TabSimb[pos].endereco); 
            }
        | T_INICIO_VETOR expr
            {

                int t = desempilha();
                int p = desempilha();
                if(t == 'l') {
                    erro("Tipo do indice deve ser inteiro");
                }
                if(TabSimb[p].cat != 'a') {
                    erro("Variavel nao e um vetor");
                }
                fprintf(yyout, "\tLEIA\n");
                fprintf(yyout, "\tARZV\t%d\n", TabSimb[p].endereco);
            } T_FIM_VETOR
        ;
    posicaoAux
        : 
            {
            
            }
        | T_INICIO_VETOR expr
            {
                int t = desempilha();
                int p = desempilha();
                if(t == 'l') {
                    erro("Tipo do indice deve ser inteiro");
                }
                if(TabSimb[p].cat != 'a') {
                    erro("Variavel nao e um vetor");
                }
                empilha(p);
            } 
            T_FIM_VETOR
        ;
    termo
        : T_IDENTIF
            {
                int pos = busca_simbolo(atomo);
                    if(pos == -1)
                        erro ("Variável não declarada!");
                empilha(TabSimb[pos].tipo);	
                empilha(pos);
            }
            indice
        | T_NUMERO
            { 
                fprintf(yyout, "\tCRCT\t%s\n", atomo);    
                empilha('i');
            }
        | T_V
            { 
                fprintf(yyout, "\tCRCT\t1\n");     
                empilha('l');
            }
        | T_F
            { 
                fprintf(yyout, "\tCRCT\t0\n");     
                empilha('l');
            }
        | T_NAO termo
            { 
                char t = desempilha();
                if(t != 'l')
                    erro("Incompatibilidade de tipos!");
                empilha('l');
                fprintf(yyout, "\tNEGA\n");        
            }
        | T_ABRE expr T_FECHA
        ;

%%

void erro (char * s){
    printf("ERRO na linha %d: %s\n", nlinha, s);
    exit(10);
    
}

int yyerror (char *s){
    erro ("Erro sintatico");
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
        printf("\nPrograma ok!\n");
    }
}