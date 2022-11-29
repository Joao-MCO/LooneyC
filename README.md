# LooneyC


bison -d parser.y --debug
flex lexer.l
g++ parser.tab.c lex.yy.c -o LooneyCompiler
LooneyCompiler teste.cbr
g++ teste.cbr.cc -o saida_teste
saida_teste
