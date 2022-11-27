#include <stdlib.h>
#include <stdio.h>
#include <string.h>

const char digitos[10] = "0123456789";
const char letras[26] = "abcdefghijklmnopqrstuvwxyz";
const char simbolos[30][5] = {'=','+','-','*','/',"%%",'!','&','|',';','.',"==","!=","<=",">=",'<','>','{','}','(',')'};
const char palavrasReservadas[14][50] = {"qqhavelinho", "issoetudopessoal","char", "bool", "pato", "coelho", "sesese", "senananao",
                                            "loolooloop", "int", "real", "toonIn", "toonOut"};

void openFile(char* caminho, FILE *arq, char* tipo);
void readFile(FILE *arq, int tamanho, char destino[1000][240]);
void writeFile(char texto[1000][240], FILE *arq, int tamanho);

int main(int argc, char const *argv[]){
    FILE *arq;
    int tamanho;
    char caminho[240];
    char destino[1000][240];
    scanf("%s", caminho);
    fflush (stdin); 
    openFile(caminho, arq, "r");
    printf("Parte 0\n");
    readFile(arq, tamanho, destino);
    printf("Parte 2\n");
    openFile("saida.txt", arq, "w+");
    writeFile(destino, arq, tamanho);
    return 0;
}

void openFile(char* caminho, FILE *arq, char* tipo){
    arq = fopen(caminho, tipo);
    if(arq == NULL){
        printf("O arquivo %s nao aberto!! Tente novamente...\n", caminho);
    }else{
        printf("O arquivo %s foi aberto com sucesso com o metodo %s!\n", caminho, tipo);
    }
}

void readFile(FILE *arq, int tamanho, char destino[1000][240]){
    int cont = 0;
    char aux[240];
    char texto[1000][240];
    printf("Parte 1\n");
    while(!feof(arq)){
        fgets(aux, 240, arq);
        printf("%s\n", aux);
        strcpy(texto[cont], aux);
        cont++;
    }
    fclose(arq);
    printf("Dados liddos com sucesso!\n");
    tamanho = cont;
    destino = texto;
}

void writeFile(char texto[1000][240], FILE *arq, int tamanho){
    int i;
    for(i=0;i<tamanho;i++){
        fprintf(arq, "%s", texto[i]);
    }
    fclose(arq);
    printf("Dados gravados com sucesso!\n");
}
