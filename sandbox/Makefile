#include ../make.inc

CC = gcc
FC = gfortran

AR := ar
ARFLAGS := -r

all: test_cfi.x test_string.x

test_cfi.x: test_cfi.F90 foo_cfi.c
	$(CC) $(CFLAGS) -c foo_cfi.c -o foo_cfi.o
	$(FC) $(FCFLAGS) test_cfi.F90 foo_cfi.o -o test_cfi.x

%.x: %.o
	$(FC) $(FCFLAGS) $^ -o $@

%.o: %.F90
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f *.x *.o *.mod
