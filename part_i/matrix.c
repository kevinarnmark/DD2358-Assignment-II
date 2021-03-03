#include "matrix.h"
#include <stdlib.h>

void matmul(int n, double *c, double *a, double *b) {
	double **C, **A, **B;
	C = (double **) malloc(n*sizeof(double *));
	A = (double **) malloc(n*sizeof(double *));
	B = (double **) malloc(n*sizeof(double *));
	for (int i = 0; i<n; i++) {
		A[i] = a + i * n;
		B[i] = b + i * n;
		C[i] = c + i * n;
	}
	for (int i=0; i<n; i++) {
		for (int j=0; j<n; j++) {
			for (int k=0; k<n; k++) {
				C[i][j] +=A[i][k]*B[k][j];
			}
		}
	}
}
