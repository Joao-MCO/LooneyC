%{
    #include<string.h>
    #include<stdio.h>
    #include<stdlib.h>
	  #include"tipo.h"
	  #include"parser.tab.h"
    #define YY_DECL extern "C" int yylex()

%}

%%
"qqhavelinho"       {return INICIOMAIN;}
"issoetudopessoal"  {return ENDMAIN;}
"inteiro"           {return V_INT;}
"char"              {return V_CHAR;}
"real"              {return V_REAL;}
"toonIn"            {return IN;}
"toonOut"           {return OUT;}
"sesese"            {return OP_IF;}
"senananao"         {return OP_ELSE;}
"looolooloop"       {return LOOP;}
"="                 {return ATRIB;}
"<="                {return OP_LE;}
">="                {return OP_GE;}
"=="                {return OP_EQ;}
"!="                {return OP_NE;}
">"	                {return OP_GT;}
"<"	                {return OP_LT;}
"&"                 {return OP_AND;}
"|"                 {return OP_OR;}
"!"                 {return OP_NOT;}

[-+]?[0-9]+("."[0-9]*)? { 
  yylval.pnt->val = atof(yytext);
  return NUM;
}
[a-zA-Z][a-zA-z0-9]* { 
  strncpy(yylval.pnt->nome, yytext, 256);
  return VAR;
}

[ \t\n]             ;                   /*Espaço vazio, retorna nada*/
.                   {return *yytext;}   /*Se encontrar qualquer coisa que não foi definida, retorna o texto que leu*/


%%
int yywrap(void){
    return 1;
}