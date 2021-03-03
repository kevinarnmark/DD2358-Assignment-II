Part 3
======
To build the python module matrixpy (could not get it to work with the name matrix) either run ./make.sh or enter the following commands:

```
$ mkdir build
$ cp run_matrix.py build
$ cd build
$ cmake ..
$ make
```
To run the test program type: (from the build directory)

```
$ python3 run_matrix.py
```

**Requirements**
Python 3.8.5
numpy
Installed libmatrix.so (Part 2)
