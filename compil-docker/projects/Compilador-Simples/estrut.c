#define TAM_TAB 100
#define TAM_PIL 100

// Pilha Semantica
int Pilha[TAM_PIL];
int topo = -1;

// Tabela de Simbolos
struct elem_tab_simbolos
{
    char id[100];
    int endereco;
    char tipo;
    int tamanho;
    char cat;
} TabSimb[TAM_TAB], elem_tab;
int pos_tab;

void mostraPilha()
{
    int aux = topo;
    while( aux > 0 )
    {
        printf("%d\n", Pilha[aux]);
        aux--;
    }
    printf("-+-+-+\n");
}

// Rotina de pilha
void empilha(int valor)
{
    mostraPilha();
    if (topo == TAM_PIL)
        erro("Pilha cheia!");
    Pilha[++topo] = valor;
}

int desempilha()
{
    if (topo == -1)
        erro("Pilha vazia!");
    return Pilha[topo--];
}

int desempilha2()
{
    if(topo == -1)
        erro("Pilha vazia!");
    return Pilha[topo-=2];
}

// Rotinas da Tabela de Simbolos
// Retorna -1 se não encontra o id
int busca_simbolo(char *id)
{
    int i = pos_tab - 1;
    for (; strcmp(TabSimb[i].id, id) && i >= 0; i--)
        ;
    return i;
}

void insere_simbolo(struct elem_tab_simbolos elem)
{
    int i;
    if (pos_tab == TAM_TAB)
        erro("Tabela de Simbolos cheia!");
    i = busca_simbolo(elem.id);
    if (i != -1)
        erro("Identificador duplicado");
    TabSimb[pos_tab++] = elem;
}

void mostra_tabela()
{
    int i;
    puts("Tabela de Simbolos");
    printf("\n%3s | %30s  | %s | %s | %s | %s\n", "#", "ID", "END", "TIP", "CAT", "TAM");
    for (int i = 0; i < 62; i++)
        printf("-");
    for (int i = 0; i < pos_tab; i++)
    {
        // printf("\n%3d | %30s  | %3d | %3c\n", i, TabSimb[i].id, TabSimb[i].endereco, TabSimb[i].tipo);
        if (TabSimb[i].tipo < 108)
        {
            printf("\n%3d | %30s  | %3d | %s | %s | %d\n", i, TabSimb[i].id, TabSimb[i].endereco, "INT", TabSimb[i].cat == 'a' ? "VET" : "VAR", TabSimb[i].tamanho);
        }
        else
        {
            printf("\n%3d | %30s  | %3d | %s | %s | %d\n", i, TabSimb[i].id, TabSimb[i].endereco, "LOG", TabSimb[i].cat == 'a' ? "VET" : "VAR", TabSimb[i].tamanho);
        }
    }
    puts("\n");
}