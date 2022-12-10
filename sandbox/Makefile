#include ../make.inc

CC = gcc
FC = gfortran

AR := ar
ARFLAGS := -r

all: test_cfi.x test_string.x strings.x

foo_cfi.o: foo_cfi.c
	$(CC) $(CFLAGS) -c foo_cfi.c -o foo_cfi.o

%.x: %.F90 foo_cfi.o
	$(FC) $(FCFLAGS) $^ -o $@

%.x: %.o
	$(FC) $(FCFLAGS) $^ -o $@

%.o: %.F90
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f *.x *.o *.mod
