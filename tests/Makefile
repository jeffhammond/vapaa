include ../make.inc

AR := ar
ARFLAGS := -r

# obviously, you have to compile in ../source first
FCFLAGS += -I../source -L../source -lmpi_f08

all: test_core.x test_collectives.x test_reductions.x test_p2p.x \
     test_thread.x test_handles.x test_file.x

%.x: %.o
	$(FC) $(FCFLAGS) $^ $(MPI_LIBS) -o $@

%.o: %.F90
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f *.x *.o
