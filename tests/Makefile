include ../make.inc

AR := ar
ARFLAGS := -r

FCFLAGS += -I../source -L../source -lmpi_f08

all: test_core.x test_collectives.x test_reductions.x test_p2p.x

#test_cfi.x

test_cfi.x: test_cfi.F90 foo_cfi.c
	$(CC) $(CFLAGS) -c foo_cfi.c -o foo_cfi.o
	$(FC) $(FCFLAGS) test_cfi.F90 foo_cfi.o -o test_cfi.x

%.x: %.o #libmpi_f08.a
	$(FC) $(FCFLAGS) $^ $(MPI_LIBS) -o $@

#$(CC) $(CFLAGS) $^ $(FORTRAN_LIBS) -o $@

%.o: %.F90
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f test_cfi.x test_cfi.o foo_cfi.o
	-rm -f test_core.x test_core.o
	-rm -f test_collectives.x test_collectives.o
	-rm -f test_reductions.x test_reductions.o
	-rm -f test_p2p.x test_p2p.o
