#include <stdlib.h>
#include <stdio.h>
#include <string.h>

const char digitos[10] = "0123456789";
const char letras[26] = "abcdefghijklmnopqrstuvwxyz";
const char simbolos[30][5] = {'=','+','-','*','/',"%%",'!','&','|',';','.',"==","!=","<=",">=",'<','>','{','}','(',')'};
const char palavrasReservadas[14][50] = {"qqhavelinho", "issoetudopessoal","char", "bool", "pato", "coelho", "sesese", "senananao",
                                            "loolooloop", "int", "real", "toonIn", "toonOut"};


int main(int argc, char const *argv[]){
    //Declaração das variáveis 
    int cont = 0;
    FILE *arq1, *arq2;
    char texto[1000][240];
    char caminho[240];
    gets(caminho);
    //Após receber qual o caminho do arquivo de entrada, é hora de ler linha a linha e ar
    arq1 = fopen(caminho, "r");
    if(arq1 == NULL){
        printf("\nO arquivo %s nao aberto!! Tente novamente...\n", caminho);
    }else{
        printf("\nO arquivo %s foi aberto com sucesso!\n", caminho);
    }
    while(!feof(arq1)){
        fgets(texto[cont], 240, arq1);
        printf("%s", texto[cont]);
        cont++;
    }
    printf("\nDados lidos com sucesso!\n");
    arq2 = fopen("output.txt", "w+");
    if(arq2 == NULL){
        printf("\nO arquivo %s nao aberto!! Tente novamente...\n", caminho);
    }else{
        printf("\nO arquivo %s foi aberto com sucesso!\n", caminho);
    }
    int i;
    for(i=0;i<cont;i++){
        printf("%s\n", texto[i]);
        fprintf(arq2, "%s", texto[i]);
    }
    fclose(arq1);
    fclose(arq2);
    printf("Dados gravados com sucesso!\n");
    return 0;
}