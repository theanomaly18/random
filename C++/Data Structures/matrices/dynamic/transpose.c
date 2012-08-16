/* File: transpose.c */
#include "matrix.h"

matrix transpose(matrix m)
{
  int i,j;
  matrix result;
  /* assign row and column dimensions */
  result.row_dim = m.col_dim;
  result.col_dim = m.row_dim;
  result.element = (T**)malloc(m.col_dim * sizeof(T*));
  for (i=0; i<m.row_dim; i++)
    result.element[i] = (T*)malloc(m.row_dim * sizeof(T));
  for(i=0; i<m.col_dim; i++)
    for(j=0; j<m.row_dim; j++)
	  result.element[i][j] = m.element[j][i];
  return result;
}
