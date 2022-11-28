%{
	#include <stdio.h>
	#include <math.h> 
	#include <stdlib.h>
	#include <string.h>
	#include <cstdio>
	#include <iostream>
	#include "tipo.h"
	using namespace std;
	#define YYERROR_VERBOSE
	extern "C" int yylex();
	extern "C" int yyparse();
	extern "C" FILE *yyin;
	void yyerror(const char *s);
	void cbr_para_c(tipo *raiz);
	void sub_cbr_para_c(tipo *raiz);
	FILE *entrada, *saida;
	tipo *raiz;
	char *var_nome;   
%}

%union{
	tipo *pnt;
}

%token <pnt> FOR 		
%token <pnt> WHILE 		
%token <pnt> IF 		
%token <pnt> ELSE 		
%token <pnt> PRINTF		
%token <pnt> SCANFINT 		
%token <pnt> SCANFDOUBLE	
%token <pnt> SCANFCHAR 		
%token <pnt> NUM 		
%token <pnt> ID			
%token <pnt> EVENT 		
%token <pnt> LE			
%token <pnt> GE			
%token <pnt> EQ			
%token <pnt> NE			
%token <pnt> LT			
%token <pnt> GT			
%token <pnt> INT		
%token <pnt> DOUBLE		
%token <pnt> CHAR		
%token <pnt> AND		
%token <pnt> OR			
%token <pnt> NOT		
%token <pnt> START		
%token <pnt> END		
%token <pnt> PRINTLN 	
%type <pnt> programa
%type <pnt> listaDeEventos
%type <pnt> chamaFn
%type <pnt> letra
%type <pnt> numero
%type <pnt> atribuicao
%type <pnt> expressao
%type <pnt> comando
%type <pnt> condicao
%type <pnt> diferente
%type <pnt> igual
%type <pnt> menor
%type <pnt> maior
%type <pnt> menorIgual
%type <pnt> maiorIgual
%type <pnt> comandoSe
%type <pnt> comandoImprimir
%type <pnt> comandoRecebe
%type <pnt> comandoEnquanto
%type <pnt> comandoPara
%type <pnt> operadorLogico
%type <pnt> negacao
%type <pnt> caractere
%type <pnt> comandoPulaLinha
%type <pnt> string
%right '='
%left  '-' '+' '/' '*'

%%

/*---------------------Estrutura do programa---------------------*/

programa: START listaDeEventos END
{ 
	raiz = $2; 
} 

listaDeEventos: comando ';' 
{ 
	$$ = (tipo*)malloc(sizeof(tipo)); 
	$1->prox = 0;				
	$$ = $1; 
}
| comando ';' listaDeEventos 
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$1->prox = $3;
	$$ = $1;
}
chamaFn: '{'listaDeEventos'}' 
{ 
	$$ = $2; 
} 

/*---------------------Tipos basicos---------------------*/

numero: INT
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = INT;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}
|DOUBLE
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = DOUBLE;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}

caractere: CHAR
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = CHAR;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}

letra: ID       
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = ID;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}

string: letra string
{ 
	$$ = (tipo*)malloc(sizeof(tipo)); 			
	$1->prox = $2;
	$$ = $1;
}
|letra
;

/*---------------------Operações---------------------*/

atribuicao: numero string '=' expressao
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = '=';				
	$$->esq = $2;
	$$->prox2 = $1;					 
	$$->dir = $4;				
	$$->prox3 = NULL;				
}
|caractere string '=' '\'' expressao '\''  
{				    
	$$ = (tipo*)malloc(sizeof(tipo)); 
	$$->token = '=';
	$$->esq = $2;
	$$->prox2 = $1;
	$$->prox3 = $1;
	$$->dir = $5;
}
|numero string 
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = ';';
	$$->esq = $1;
	$$->dir = $2;
}
|caractere string 
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = ';';
	$$->esq = $1;
	$$->dir = $2;
}
| string '=' '\'' expressao '\'' 
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = '=';
	$$->esq = $1;
	$$->dir = $4;
	$$->prox3 = $1;
}
| string '=' expressao 
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = '=';
	$$->esq = $1;
	$$->dir = $3;
	$$->prox3 = NULL;
}

expressao:   string
| NUM  
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = NUM;
	$$->val = yylval.pnt->val;
	$$->esq = NULL;
	$$->esq = NULL;
}
| '-' NUM
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = NUM;
	$$->val = - yylval.pnt->val;
	$$->esq = NULL;
	$$->esq = NULL;
}
| expressao '+' expressao
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = '+';
	$$->esq = $1;
	$$->dir = $3;
}
| expressao '-' expressao	  
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = '-';
	$$->esq = $1;
	$$->dir = $3;
}
| expressao '*' expressao	  
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = '*';
	$$->esq = $1;
	$$->dir = $3;
}
| expressao '/' expressao	  
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = '/';
	$$->esq = $1;
	$$->dir = $3;
}
| expressao '%' expressao
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = '%';
	$$->esq = $1;
	$$->dir = $3;
}
|'(' expressao ')'
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$ = $2;
}


/*---------------------Operações Lógicas---------------------*/

condicao: igual
| maior
| menor
| maiorIgual
| menorIgual
| diferente
;

operadorLogico: AND
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = AND;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}
|OR
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = OR;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}

negacao: NOT '(' condicao ')'
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = NOT;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = $3;
	$$->dir = NULL;
}

diferente: expressao NE expressao     
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = NE;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao NE expressao')' operadorLogico condicao     
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = NE;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

igual: expressao EQ expressao     
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = EQ;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao EQ expressao')' operadorLogico condicao
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = EQ;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

menor: expressao LT expressao     
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = LT;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao LT expressao')' operadorLogico condicao
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = LT;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

maior: expressao GT expressao     
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = GT;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao GT expressao')' operadorLogico condicao
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = GT;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

menorIgual: expressao LE expressao     
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = LE;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao LE expressao')' operadorLogico condicao
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = LE;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

maiorIgual: expressao GE expressao     
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = GE;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao GE expressao')' operadorLogico condicao 
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = GE;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

/*---------------------Comandos---------------------*/

comando:  atribuicao
| chamaFn
| comandoEnquanto
| comandoPara
| comandoSe
| comandoImprimir
| comandoRecebe
| comandoPulaLinha
;

comandoSe:  IF '(' condicao ')' chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = IF;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = NULL;
}
|IF '(' negacao ')' chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = IF;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = NULL;
}
| IF '(' condicao ')' chamaFn ELSE chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = IF;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = $7;
}
| IF '(' negacao ')' chamaFn ELSE chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = IF;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = $7;
}

comandoImprimir: PRINTF '('  string  ')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = PRINTF; 
	$$->esq = $3;
	$$->dir = NULL;
}
|PRINTF '('string '+' numero string ')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = PRINTF; 
	$$->esq = $3;
	$$->dir = $5;
	$$->prox1 = $6;
}
|PRINTF '('string '+' caractere string ')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = PRINTF; 
	$$->esq = $3;
	$$->dir = $5;
	$$->prox1 = $6;
}

comandoPulaLinha: PRINTLN
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = PRINTLN; 
	$$->esq = NULL;
	$$->dir = NULL;
}

comandoRecebe: SCANFINT '('string')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = SCANFINT; 
	$$->esq = $3;
	$$->dir = NULL;
}
|SCANFDOUBLE '(' string  ')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = SCANFDOUBLE; 
	$$->esq = $3;
	$$->dir = NULL;
}
|SCANFCHAR '(' string  ')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = SCANFCHAR; 
	$$->esq = $3;
	$$->dir = NULL;
}

comandoPara: FOR '('atribuicao':'condicao':'atribuicao')' chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = FOR;
	$$->prox1 = $3;
	$$->prox2 = $5;
	$$->prox3 = $7;
	$$->esq = $9;
	$$->dir = NULL;
}

comandoEnquanto: WHILE '(' condicao ')' chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = WHILE;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = NULL;
}

/*---------------------Conversor CBr para C---------------------*/

%%
int main(int argc, char *argv[])
{
  char buffer[256];
  extern FILE *yyin;
  yylval.pnt = (tipo*)malloc(sizeof(tipo));
  if (argc < 2){
    printf("Erro tipo 1: Ação invalida!\n");
    exit(1);
  }
    entrada = fopen(argv[1],"r");
  if(!entrada){
    printf("Erro tipo 2, arquivo nao encontrado.\n");
    exit(1);
  }
  yyin = entrada;
  strcpy(buffer,argv[1]);
  strcat(buffer,".cc");  
  saida = fopen(buffer,"w");
  if(!saida){
    printf("Erro tipo 3, arquivo de saida invalido.\n");
    exit(1);
  }
  yyparse();
  fprintf(saida,"#include<string.h>\n");
  fprintf(saida,"#include<stdio.h>\n");
  fprintf(saida,"#include<math.h>\n");	
  fprintf(saida,"\nint main(int argc, char *argv[]){\n");
  cbr_para_c(raiz);
  fprintf(saida,"\nreturn 0;\n");
  fprintf(saida,"\n}\n");
  fclose(entrada);
  fclose(saida);
}

void yyerror(const char *s) {
  printf("%s\n", s);
}

/*---------------------Funções para conversão de CBr para C---------------------*/

void cbr_para_c(tipo *raiz){
	if (raiz != NULL){
	switch(raiz->token){
		case NUM:
			fprintf(saida,"%g", raiz->val);
			break;
		case ID:
			fprintf(saida,"%s ", raiz->nome);
			break;
		case INT:
			fprintf(saida,"int ");
			break;
		case DOUBLE:
			fprintf(saida,"double ");
			break;
		case CHAR:
			fprintf(saida,"char ");
			break;
		case '=':
			if(raiz->prox3==NULL){
				cbr_para_c(raiz->prox2);
				cbr_para_c(raiz->esq);
				fprintf(saida,"= ");
				cbr_para_c(raiz->dir);
				fprintf(saida,";\n");
				break;
			}else{
				cbr_para_c(raiz->prox2);
				cbr_para_c(raiz->esq);
				fprintf(saida,"= ");
				fprintf(saida," '");
				cbr_para_c(raiz->dir);
				fprintf(saida,"' ");
				fprintf(saida,";\n");
				break;
			}
		case ';':
			cbr_para_c(raiz->esq);
			fprintf(saida," ");
			cbr_para_c(raiz->dir);
			fprintf(saida,";\n");
			break;
		case '+':
			cbr_para_c(raiz->esq);
			fprintf(saida,"+");
			cbr_para_c(raiz->dir);
			break;
		case '-':
			cbr_para_c(raiz->esq);
			fprintf(saida,"-");
			cbr_para_c(raiz->dir);
			break;
		case '*':
			cbr_para_c(raiz->esq);
			fprintf(saida,"*");
			cbr_para_c(raiz->dir);
			break;
		case '/':
			cbr_para_c(raiz->esq);
			fprintf(saida,"/");
			cbr_para_c(raiz->dir);
			break;
		case '%':
			fprintf(saida,"int(");
			cbr_para_c(raiz->esq);
			fprintf(saida,")");
			fprintf(saida,"%%");
			fprintf(saida,"int(");
			cbr_para_c(raiz->dir);
			fprintf(saida,")");
			break;
		case ',':
			cbr_para_c(raiz->esq);
			fprintf(saida,",");
			cbr_para_c(raiz->dir);
			break;

		case EQ:
		if(raiz->prox1==NULL){
			cbr_para_c(raiz->esq);
			fprintf(saida,"== ");
			cbr_para_c(raiz->dir);
			break;
		}else{
			cbr_para_c(raiz->esq);
			fprintf(saida,"== ");
			cbr_para_c(raiz->dir);
			cbr_para_c(raiz->prox1);
			fprintf(saida,"(");
			cbr_para_c(raiz->prox2);
			fprintf(saida,")");
			break;
		}
		case NE:
			if(raiz->prox1==NULL){
				cbr_para_c(raiz->esq);
				fprintf(saida,"!= ");
				cbr_para_c(raiz->dir);
				break;
			}else{
				cbr_para_c(raiz->esq);
				fprintf(saida,"!= ");
				cbr_para_c(raiz->dir);
				cbr_para_c(raiz->prox1);
				fprintf(saida,"(");
				cbr_para_c(raiz->prox2);
				fprintf(saida,")");
				break;
			}
		
		case GT:
			if(raiz->prox1==NULL){
				cbr_para_c(raiz->esq);
				fprintf(saida,"> ");
				cbr_para_c(raiz->dir);
				break;
			}else{
				cbr_para_c(raiz->esq);
				fprintf(saida,"> ");
				cbr_para_c(raiz->dir);
				cbr_para_c(raiz->prox1);
				fprintf(saida,"(");
				cbr_para_c(raiz->prox2);
				fprintf(saida,")");
				break;
			}
		case LT:
			if(raiz->prox1==NULL){
				cbr_para_c(raiz->esq);
				fprintf(saida,"< ");
				cbr_para_c(raiz->dir);
				break;
			}else{
				cbr_para_c(raiz->esq);
				fprintf(saida,"< ");
				cbr_para_c(raiz->dir);
				cbr_para_c(raiz->prox1);
				fprintf(saida,"(");
				cbr_para_c(raiz->prox2);
				fprintf(saida,")");
				break;
			}

		case GE:
			if(raiz->prox1==NULL){
				cbr_para_c(raiz->esq);
				fprintf(saida,">= ");
				cbr_para_c(raiz->dir);
				break;
			}else{
				cbr_para_c(raiz->esq);
				fprintf(saida,">= ");
				cbr_para_c(raiz->dir);
				cbr_para_c(raiz->prox1);
				fprintf(saida,"(");
				cbr_para_c(raiz->prox2);
				fprintf(saida,")");
				break;
			}
		case LE:
			if(raiz->prox1==NULL){
				cbr_para_c(raiz->esq);
				fprintf(saida,"<= ");
				cbr_para_c(raiz->dir);
				break;
			}else{
				cbr_para_c(raiz->esq);
				fprintf(saida,"<= ");
				cbr_para_c(raiz->dir);
				cbr_para_c(raiz->prox1);
				fprintf(saida,"(");
				cbr_para_c(raiz->prox2);
				fprintf(saida,")");
				break;
			}
		case EVENT:
			cbr_para_c(raiz->prox1);
			fprintf(saida,"(");
			cbr_para_c(raiz->esq);
			fprintf(saida,")");
			fprintf(saida,";\n");
			break;

		case '.':
			cbr_para_c(raiz->esq);
			fprintf(saida," ");
			cbr_para_c(raiz->dir);
			fprintf(saida," ");
			break;
		
		case IF:
			fprintf(saida," \nif ");
			fprintf(saida,"(");
			cbr_para_c(raiz->prox1);
			fprintf(saida,")");
			fprintf(saida," {\n");
			cbr_para_c(raiz->esq);
			fprintf(saida,"\n}");
		
			if(raiz->dir != NULL){
				fprintf(saida,"\n else");
				fprintf(saida," {\n");
				cbr_para_c(raiz->dir);
				fprintf(saida," }\n");
			}
			else fprintf(saida,"\n");
			break;
      
		case WHILE:
			fprintf(saida," \nwhile ");
			fprintf(saida,"(");
			cbr_para_c(raiz->prox1);
			fprintf(saida,")");
			fprintf(saida," {\n");
			cbr_para_c(raiz->esq);
			fprintf(saida," }");
			break;

		case FOR:
			fprintf(saida,"\n for");
			fprintf(saida,"(");
			sub_cbr_para_c(raiz->prox1);
			fprintf(saida,"; ");
			cbr_para_c(raiz->prox2);
			fprintf(saida,"; ");
			sub_cbr_para_c(raiz->prox3);
			fprintf(saida,")");
			fprintf(saida,"{\n");
			cbr_para_c(raiz->esq);
			fprintf(saida,"\n} \n");
			break;

		case AND:
			fprintf(saida,"&&");
			break;

		case OR:
			fprintf(saida,"||");
			break;

		case NOT:
			fprintf(saida,"!");
			fprintf(saida,"(");
			cbr_para_c(raiz->esq);
			fprintf(saida,")");
			break;

		case SCANFINT:
			fprintf(saida," \n scanf");
			fprintf(saida,"(");
			fprintf(saida,"\"");
			fprintf(saida,"%%d");
			fprintf(saida,"\"");
			fprintf(saida,",");
			fprintf(saida,"&");
			cbr_para_c(raiz->esq);
			fprintf(saida,")");
			fprintf(saida,"; ");
			fprintf(saida,"\n");
			break;

		case SCANFCHAR:
			fprintf(saida," \n scanf");
			fprintf(saida,"(");
			fprintf(saida,"\"");
			fprintf(saida,"%%c");
			fprintf(saida,"\"");
			fprintf(saida,",");
			fprintf(saida,"&");
			cbr_para_c(raiz->esq);
			fprintf(saida,")");
			fprintf(saida,"; ");
			fprintf(saida,"\n");
			break;

		case SCANFDOUBLE:
			fprintf(saida," \n scanf");
			fprintf(saida,"(");
			fprintf(saida,"\"");
			fprintf(saida,"%%e");
			fprintf(saida,"\"");
			fprintf(saida,",");
			fprintf(saida,"&");
			cbr_para_c(raiz->esq);
			fprintf(saida,")");
			fprintf(saida,"; ");
			fprintf(saida,"\n");
			break;
		case PRINTLN:
			fprintf(saida," \n printf");
			fprintf(saida,"(");
			fprintf(saida,"\"");
			fprintf(saida,"\\n");
			fprintf(saida,"\"");
			fprintf(saida,")");
			fprintf(saida,"; ");
			fprintf(saida,"\n");
			break;	

		case PRINTF:
			if(raiz->dir==NULL){
				fprintf(saida," \n printf");
				fprintf(saida,"(");
				fprintf(saida,"\"");
				cbr_para_c(raiz->esq);
				fprintf(saida,"\"");
				fprintf(saida,")");
				fprintf(saida,"; ");
				fprintf(saida,"\n");
				break;
			}
			else{
				fprintf(saida," \n printf");
				fprintf(saida,"(");
				fprintf(saida,"\"");
				cbr_para_c(raiz->esq);
				fprintf(saida," ");
				if(raiz->dir->token== INT){
					fprintf(saida,"%%d");        
					fprintf(saida,"\"");
					fprintf(saida,",");
					cbr_para_c(raiz->prox1);
					fprintf(saida,")");
					fprintf(saida,"; ");
					fprintf(saida,"\n");
					break;
				}else if (raiz->dir->token== DOUBLE){
					fprintf(saida,"%%e");        
					fprintf(saida,"\"");
					fprintf(saida,",");
					cbr_para_c(raiz->prox1);
					fprintf(saida,")");
					fprintf(saida,"; ");
					fprintf(saida,"\n");
					break;
				}else if (raiz->dir->token== CHAR){
					fprintf(saida,"%%c");        
					fprintf(saida,"\"");
					fprintf(saida,",");
					cbr_para_c(raiz->prox1);
					fprintf(saida,")");
					fprintf(saida,"; ");
					fprintf(saida,"\n");
					break;
				}else{
					fprintf(saida,"%%d");       
					fprintf(saida,"\"");
					fprintf(saida,",");
					cbr_para_c(raiz->prox1);
					fprintf(saida,")");
					fprintf(saida,"; ");
					fprintf(saida,"\n");
					break;
				}
			}
		default: 
			fprintf(saida,"Desconhecido: Token = %d (%c) \n", raiz->token, raiz->token);
	}
		if (raiz->prox != NULL) {
		cbr_para_c(raiz->prox);
	}
  }
}

void sub_cbr_para_c(tipo *raiz){
	if (raiz != NULL){
	switch(raiz->token){
		case '=':
			if(raiz->prox3==NULL){
				cbr_para_c(raiz->prox2);
				cbr_para_c(raiz->esq);
				fprintf(saida,"= ");
				cbr_para_c(raiz->dir);
				break;
			}else{
				cbr_para_c(raiz->prox2);
				cbr_para_c(raiz->esq);
				fprintf(saida,"= ");
				fprintf(saida," '");
				cbr_para_c(raiz->dir);
				fprintf(saida,"' ");
				break;
			}
		default: 
			fprintf(saida,"Desconhecido: Token = %d (%c) \n", raiz->token, raiz->token);
	}
		if (raiz->prox != NULL) {
		cbr_para_c(raiz->prox);
	}
  }
}