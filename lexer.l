%{
    #include<stdio.h>
    #include<stdlib.h>
    #include
%}

%%
"qqhavelinho"       {return INICIOMAIN;}
"issoetudopessoal"  {return ENDMAIN;}
"/f"                {return FIMLINHA;}
"inteiro"           {return V_INT;}
"char"              {return V_CHAR;}
"real"              {return V_REAL;}
"toonIn"            {return IN;}
"toonOut"           {return OUT;}
"sesese"            {return OP_IF;}
"senananao"         {return OP_ELSE;}
"looolooloop"       {return LOOP;}
"="                 {return ATRIB;}
"+"                 {return OP_SOMA;}
"-"                 {return OP_SUB;}
"*"                 {return OP_MULTI;}
"/"                 {return OP_DIV;}
"%"                 {return MOD;}
"."                 {return PONTO;}
";"                 {return PEV;}
"("                 {return L_PAR;}
")"                 {return R_PAR;}
"{"                 {return S_BLOCK;}
"}"                 {return E_BLOCK;}
"=="|"<="|">="|"!="|">"|"<" {return OP_RELA;} 
"&"|"|"|"!"         {return OP_LOGI;}

[-+]?[0-9]+("."[0-9]*)?{ 
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
    retunr 1;
}
