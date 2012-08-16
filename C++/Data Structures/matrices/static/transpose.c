/* File: transpose.c */
#include "matrix.h"

matrix transpose(matrix m)
{
  int i,j;
  matrix result;
  /* assign row and column dimensions */
  result.row_dim = m.col_dim;
  result.col_dim = m.row_dim;
  for(i=0; i<m.col_dim; i++)
    for(j=0; j<m.row_dim; j++)
	  result.element[i][j] = m.element[j][i];
  return result;
}
