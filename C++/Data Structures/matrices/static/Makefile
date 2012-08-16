test_static: matrix.o transpose.o test.o
	gcc -o test_static matrix.o transpose.o test.o

matrix.o: matrix.c matrix.h
	gcc -Wall -g -c matrix.c

transpose.o: transpose.c matrix.h
	gcc -Wall -g -c transpose.c

test.o: test.c matrix.h
	gcc -Wall -g -c test.c

clean:
	rm *.o

