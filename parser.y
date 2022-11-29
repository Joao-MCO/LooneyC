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

%token <pnt> LOOP		
%token <pnt> OP_IF 		
%token <pnt> OP_ELSE 		
%token <pnt> OUT	
%token <pnt> IN 
%token <pnt> VAR 
%token <pnt> NUM 		
%token <pnt> EVENT 
%token <pnt> OP_LE			
%token <pnt> OP_GE			
%token <pnt> OP_EQ			
%token <pnt> OP_NE			
%token <pnt> OP_LT			
%token <pnt> OP_GT	
%token <pnt> OP_AND		
%token <pnt> OP_OR			
%token <pnt> OP_NOT
%token <pnt> ATRIB
%token <pnt> V_INT		
%token <pnt> V_REAL		
%token <pnt> V_CHAR
%token <pnt> INICIOMAIN		
%token <pnt> ENDMAIN		
	

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
%type <pnt> comandoLoop
%type <pnt> operadorLogico
%type <pnt> negacao
%type <pnt> caractere
%type <pnt> string
%right '='
%left  '-' '+' '/' '*'

%%

/*---------------------Estrutura do programa---------------------*/

programa: INICIOMAIN listaDeEventos ENDMAIN
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

numero: V_INT
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = V_INT;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}
|V_REAL
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = V_REAL;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}

caractere: V_CHAR
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = V_CHAR;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}

letra: VAR       
{ 
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = VAR;
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

operadorLogico: OP_AND
{ 
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_AND;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}
|OP_OR
{ 
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_OR;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = NULL;
	$$->dir = NULL;
}

negacao: OP_NOT '(' condicao ')'
{ 
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_NOT;
	strcpy($$->nome, yylval.pnt->nome);
	$$->esq = $3;
	$$->dir = NULL;
}

diferente: expressao OP_NE expressao     
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_NE;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao OP_NE expressao')' operadorLogico condicao     
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_NE;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

igual: expressao OP_EQ expressao     
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_EQ;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao OP_EQ expressao')' operadorLogico condicao
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_EQ;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

menor: expressao OP_LT expressao     
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_LT;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao OP_LT expressao')' operadorLogico condicao
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_LT;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

maior: expressao OP_GT expressao     
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_GT;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao OP_GT expressao')' operadorLogico condicao
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_GT;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

menorIgual: expressao OP_LE expressao     
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_LE;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao OP_LE expressao')' operadorLogico condicao
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_LE;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

maiorIgual: expressao OP_GE expressao     
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_GE;
	$$->esq = $1;
	$$->dir = $3;
	$$->prox1 = NULL;
}
| '('expressao OP_GE expressao')' operadorLogico condicao 
{
	$$ = (No*)malloc(sizeof(No));
	$$->token = OP_GE;
	$$->esq = $2;
	$$->dir = $4;
	$$->prox1 = $6;
	$$->prox2 = $7;
}

/*---------------------Comandos---------------------*/

comando:  atribuicao
| chamaFn
| comandoLoop
| comandoSe
| comandoImprimir
| comandoRecebe
;

comandoSe:  OP_IF '(' condicao ')' chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = OP_IF;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = NULL;
}
|OP_IF '(' negacao ')' chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = OP_IF;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = NULL;
}
| OP_IF '(' condicao ')' chamaFn OP_ELSE chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = OP_IF;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = $7;
}
| OP_IF '(' negacao ')' chamaFn OP_ELSE chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = OP_IF;
	$$->prox1 = $3;
	$$->esq = $5;
	$$->dir = $7;
}

comandoImprimir: OUT '('  string  ')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = OUT; 
	$$->esq = $3;
	$$->dir = NULL;
}
|OUT '('string '+' numero string ')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = OUT; 
	$$->esq = $3;
	$$->dir = $5;
	$$->prox1 = $6;
}
|OUT '('string '+' caractere string ')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = OUT; 
	$$->esq = $3;
	$$->dir = $5;
	$$->prox1 = $6;
}



comandoRecebe: IN '('string')'
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = IN; 
	$$->esq = $3;
	$$->dir = NULL;
}



comandoLoop: LOOP '(' condicao ')' chamaFn
{
	$$ = (tipo*)malloc(sizeof(tipo));
	$$->token = LOOP;
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
		case VAR:
			fprintf(saida,"%s ", raiz->nome);
			break;
		case V_INT:
			fprintf(saida,"int ");
			break;
		case V_REAL:
			fprintf(saida,"double ");
			break;
		case V_CHAR:
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

		case OP_EQ:
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
		case OP_NE:
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
		
		case OP_GT:
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
		case OP_LT:
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

		case OP_GE:
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
		case OP_LE:
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
		
		case OP_IF:
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
      
		case LOOP:
			fprintf(saida," \nwhile ");
			fprintf(saida,"(");
			cbr_para_c(raiz->prox1);
			fprintf(saida,")");
			fprintf(saida," {\n");
			cbr_para_c(raiz->esq);
			fprintf(saida," }");
			break;


		case OP_AND:
			fprintf(saida,"&&");
			break;

		case OP_OR:
			fprintf(saida,"||");
			break;

		case OP_NOT:
			fprintf(saida,"!");
			fprintf(saida,"(");
			cbr_para_c(raiz->esq);
			fprintf(saida,")");
			break;

		case IN:
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



		case OUT:
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
				if(raiz->dir->token== V_INT){
					fprintf(saida,"%%d");        
					fprintf(saida,"\"");
					fprintf(saida,",");
					cbr_para_c(raiz->prox1);
					fprintf(saida,")");
					fprintf(saida,"; ");
					fprintf(saida,"\n");
					break;
				}else if (raiz->dir->token== V_REAL){
					fprintf(saida,"%%e");        
					fprintf(saida,"\"");
					fprintf(saida,",");
					cbr_para_c(raiz->prox1);
					fprintf(saida,")");
					fprintf(saida,"; ");
					fprintf(saida,"\n");
					break;
				}else if (raiz->dir->token== V_CHAR){
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