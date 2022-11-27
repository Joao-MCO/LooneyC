#include <stdlib.h>
#include <stdio.h>
#include <string.h>

const char digitos[10] = "0123456789";
const char letras[26] = "abcdefghijklmnopqrstuvwxyz";
const char simbolos[30][5] = {'=','+','-','*','/',"%%",'!','&','|',';','.',"==","!=","<=",">=",'<','>','{','}','(',')'};
const char palavrasReservadas[14][50] = {"qqhavelinho", "issoetudopessoal","char", "bool", "pato", "coelho", "sesese", "senananao",
                                            "loolooloop", "int", "real", "toonIn", "toonOut"};


int readFile(FILE *arq, char *destino[240], char caminho[240], char tipo[3]);
void writeFile(char **texto, FILE *arq, int tamanho, char caminho[240], char tipo[3]);

int main(int argc, char const *argv[]){
    FILE *arq;
    int tamanho;
    char caminho[240];
    char** destino;
    destino =  (char **) malloc(1000 * sizeof(char *));
    int i;
    for(i=0;i<1000;i++){
        destino[i] = (char *) malloc(240*sizeof(char));
    }
    gets(caminho);
    tamanho = readFile(arq, destino, caminho, "r");
    // openFile("saida.txt", arq, "w+");
    writeFile(destino, arq, tamanho, "output.txt", "w+");
    return 0;
}

int readFile(FILE *arq, char *destino[240], char caminho[240], char tipo[3]){
    arq = fopen(caminho, tipo);
    if(arq == NULL){
        printf("\nO arquivo %s nao aberto!! Tente novamente...\n", caminho);
    }else{
        printf("\nO arquivo %s foi aberto com sucesso com o metodo %s!\n", caminho, tipo);
    }
    int cont = 0;
    char texto[1000][240];
    printf("Parte 1\n");
    while(!feof(arq)){
        fgets(texto[cont], 240, arq);
        printf("%s", texto[cont]);
        cont++;
    }
    fclose(arq);
    printf("\nDados lidos com sucesso!\n");
    **destino = **texto;
    return cont;
}

void writeFile(char **texto, FILE *arq, int tamanho, char caminho[240], char tipo[3]){
    arq = fopen(caminho, tipo);
    if(arq == NULL){
        printf("\nO arquivo %s nao aberto!! Tente novamente...\n", caminho);
    }else{
        printf("\nO arquivo %s foi aberto com sucesso com o metodo %s!\n", caminho, tipo);
    }
    int i;
    for(i=0;i<tamanho;i++){
        printf("%s\n", texto[i], i, tamanho);
        fprintf(arq, "%s", texto[i]);
    }
    fclose(arq);
    printf("Dados gravados com sucesso!\n");
}
