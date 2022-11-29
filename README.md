# LooneyC


![LooneyC](https://user-images.githubusercontent.com/83473685/204421744-1f4acc0e-1072-4ffa-8656-a272cee3fd24.png)
![GitHub last commit](https://img.shields.io/github/last-commit/Joao-MCO/LooneyC?style=flat-square)

##
Projeto de um compilador para a disciplina de ECOM06, tématico de LooneyTunes, usando Flex e Bison.

## Como usar
Instale Flex e Bison em sua máquina, em seguida rode estes comandos pelo terminal na pasta com os arquivos do projeto.
```bash
#compila o parser
bison -d parser.y --debug
#compila o lexer
flex lexer.l
#compila o lexer e o parser pelo compilador C
g++ parser.tab.c lex.yy.c -o LooneyCompiler
#Roda o teste
LooneyCompiler teste.loc
g++ teste.loc.cc -o saida_teste
saida_teste
```
