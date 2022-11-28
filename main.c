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
    int i;
    int contLinhas = 0, contPalavras = 0; // Contador de linhas e palavras
    FILE *arq1, *arq2; 
    char texto[1000][240]; //Vector de String que armazena cada linha lida do arq1
    char separado[5000][240]; //Vector de String que armazena cada palavra do arq1
    char caminho[240]; //Caminho para o arq1
    gets(caminho);
    //Após receber qual o caminho do arquivo de entrada, é hora de ler linha a linha e armazenar na matriz texto
    arq1 = fopen(caminho, "r");
    if(arq1 == NULL){
        printf("\nO arquivo %s nao aberto!! Tente novamente...\n", caminho);
    }else{
        printf("\nO arquivo %s foi aberto com sucesso!\n", caminho);
    }
    while(!feof(arq1)){
        fgets(texto[contLinhas], 240, arq1);
        printf("%s", texto[contLinhas]);
        contLinhas++;
    }
    printf("\nDados lidos com sucesso!\n");
    //Dividir as entradas através dos espaços
    for(i=0;i<contLinhas;i++){
        int init_size = strlen(texto[i]); //Tamanho da linha i do arq1
	    char delim[] = " "; //Aonde vai dividir a linha, nesse caso, no espaço
	    char *ptr = strtok(texto[i], delim);
	    while (ptr != NULL){
            strcpy(separado[contPalavras], ptr);
		    ptr = strtok(NULL, delim);
            strcat(separado[contPalavras],"\n");
            printf("%s",separado[contPalavras]);
            contPalavras++;
        }
    }
    //Agora é retornar o arquivo
    arq2 = fopen("output.txt", "w+");
    if(arq2 == NULL){
        printf("\nO arquivo output.txt nao aberto!! Tente novamente...\n");
    }else{
        printf("\nO arquivo output.txt foi aberto com sucesso!\n");
    }
    for(i=0;i<contPalavras;i++){
        fprintf(arq2, "%s", separado[i]);
    }
    fclose(arq1);
    fclose(arq2);
    printf("Dados gravados com sucesso!\n");
    return 0;
}