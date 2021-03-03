Part I
======
To build this shared library, simply run make.sh or use the following commands:

```
$ gcc -fPIC  -Wall -O3 -c matrix.c -o matrix.o
$ gcc -shared -o libmatrix.so matrix.o
```
If you want to install the shared library it could be done by copying the shared library to your local library. E.g. if it is located at /usr/local/lib/ run the following command: 
```
$ sudo cp libmatrix.so /usr/local/lib/libmatrix.so
```
