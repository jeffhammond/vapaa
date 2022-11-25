include ../make.inc

AR := ar
ARFLAGS := -r

# obviously, you have to compile in ../source first
FCFLAGS += -I../source -L../source -lmpi_f08

all: test_core.x test_collectives.x test_reductions.x test_p2p.x

%.x: %.o
	$(FC) $(FCFLAGS) $^ $(MPI_LIBS) -o $@

%.o: %.F90
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f test_core.x test_core.o
	-rm -f test_collectives.x test_collectives.o
	-rm -f test_reductions.x test_reductions.o
	-rm -f test_p2p.x test_p2p.o
