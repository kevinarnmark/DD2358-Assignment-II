#include <pybind11/pybind11.h>
#include <pybind11/numpy.h>
#include <stdio.h>
extern "C" {
	#include "matrix.h"
}
namespace py = pybind11;

void matmul_wrapper(py::array_t<double> py_c,py::array_t<double> py_a, py::array_t<double> py_b);

void matmul_wrapper(py::array_t<double> py_c,py::array_t<double> py_a, py::array_t<double> py_b) {
	
	py::buffer_info a_buffer = py_a.request();
	py::buffer_info b_buffer = py_b.request();
	py::buffer_info c_buffer = py_c.request();
	
	if (a_buffer.shape[0] != b_buffer.shape[0] || a_buffer.shape[0] != c_buffer.shape[0]) {
		throw std::runtime_error("Error: size of A, B or C does not match");
	}

	if (a_buffer.shape[0] != a_buffer.shape[1] || b_buffer.shape[0] != b_buffer.shape[1] || c_buffer.shape[0] != c_buffer.shape[1]) {
		throw std::runtime_error("Error: A, B and C must be square matrices");
	}

	double *a = (double *)a_buffer.ptr;
	double *b = (double *)b_buffer.ptr;
	double *c = (double *)c_buffer.ptr;
	int dim = a_buffer.shape[0];
	int *n = &dim;
	matmul(n, c, a, b);
}

PYBIND11_MODULE(matrixpy, m) {                            // Create a module using the PYBIND11_MODULE macro
	m.doc() = "pybind11 matrix multiplication module";
	m.def("gemm", &matmul_wrapper, "multiply two matrices"); // calls module::def() to create generate binding code that exposes sum()
}
