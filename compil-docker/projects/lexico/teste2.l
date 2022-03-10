%{
int conta = 0;  
%}
%%
#[a-zA-Z0-9\_]* {printf("%s\n", yytext); conta++;}
.   ;
\n  ;
%%

int yywrap(){
    return 1;
}

int main(int argc, char *argv[]){
    yyin = fopen (argv[1], "rt");
    yylex();
    printf("conta = %d\n", conta);
    fclose(yyin);
}