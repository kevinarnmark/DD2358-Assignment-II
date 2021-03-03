echo "Compiling matrix.c"
gcc -fPIC  -Wall -O3 -c matrix.c -o matrix.o
echo "Creating shared library libmatrix.so"
gcc -shared -o libmatrix.so matrix.o

# Uncomment the next line to install the shared library to /usr/local/lib/
# sudo cp libmatrix.so /usr/local/lib/
