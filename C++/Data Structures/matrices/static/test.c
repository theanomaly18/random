/* File: test.c */
#include "matrix.h"

int main() 
{
  static T data[] = {1,2,3,4,5,6,7,8,9};
  matrix  a,b;
  a = create_initvals(3,3,data);
  b = create_empty(3,3);
  equate(&a,&b);
  printf("\n Matrix a:");
  matrix_print(a);
  printf("\n Matrix b:");
  matrix_print(b);
  printf("\n a+b:");
  matrix_print(add(a,b));
  printf("\n a transposed:");
  matrix_print(transpose(a));
  printf("\n a+b transposed:");
  matrix_print(transpose(add(a,b)));
  return 0;
}
