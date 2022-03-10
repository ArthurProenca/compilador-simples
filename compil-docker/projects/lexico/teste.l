%{
int nlinha = 0;  
%}
%%
^(.*)\n printf("%4d:%s\n", ++nlinha, yytext);
%%

int yywrap(){
    return 1;
}

int main(int argc, char *argv[]){
    yyin = fopen (argv[1], "rt");
    yylex();
    fclose(yyin);
}