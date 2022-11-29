# LooneyC


![LooneyC](https://user-images.githubusercontent.com/83473685/204421744-1f4acc0e-1072-4ffa-8656-a272cee3fd24.png)

bison -d parser.y --debug
 flex lexer.l
 g++ parser.tab.c lex.yy.c -o LooneyCompiler
 LooneyCompiler teste.cbr
 g++ teste.cbr.cc -o saida_teste
 saida_teste
