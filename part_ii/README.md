Part 2 
======
To build the shared library and program, enter the following commands:

```
$ mkdir build
$ cd build
$ cmake ..
$ sudo make install
```
The shared library gets installed and the program executable can be found in build/bin.
To run the executable test program type: (from the build directory)

```
$ ./bin/gemm_test.out

```
