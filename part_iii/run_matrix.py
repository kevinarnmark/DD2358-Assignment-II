import matrixpy
import numpy as np

n = 10

A = np.random.rand(n,n)
B = np.random.rand(n,n)
C = np.zeros((n,n))

matrixpy.gemm(C, A, B)

np.testing.assert_almost_equal(C, np.matmul(A, B))
print("Test OK")

