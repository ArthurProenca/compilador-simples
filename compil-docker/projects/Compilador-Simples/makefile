# +--------------------------------------------------------------------
# |             UNIFAL − Universidade Federal de Alfenas
# |              Bacharelado em Ciência da Computação
# |  Trabalho..: Vetor e verificação de tipos
# |  Disciplina: Teoria de Linguagens e Compiladores
# |  Professor.: Luiz Eduardo da Silva
# |  Aluno.....: Arthur Rodrigues Proença
# |  Data......: 06/04/2022
# +----------------------------------------------------------------------*/
calc: lexico.l sintatico.y;
	flex -o lexico.c lexico.l;\
	bison -v -d sintatico.y -o sintatico.c;\
	gcc sintatico.c -o simples;

limpa: ;
	rm lexico.c sintatico.c sintatico.h sintatico.output simples