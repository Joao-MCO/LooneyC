#ifndef _NO_H_
#define _NO_H_

struct tipo {
  int token;
  double val;
  char nome[256];
  struct tipo *esq, *dir, *prox, *prox1, *prox2, *prox3;
};

typedef struct tipo tipo;

#endif
