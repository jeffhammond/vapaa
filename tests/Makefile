include ../make.inc

AR := ar
ARFLAGS := -r

# obviously, you have to compile in ../source first
FCFLAGS += -I../source -L../source -lmpi_f08

FCFLAGS += -Wno-unused-variable -Wno-unused-dummy-argument

all: test_core.x test_collectives.x test_reductions.x test_p2p.x \
     test_thread.x test_file.x test_handles.x test_vector_noncontig.x \
     test_datatype.x test_comm.x test_user_reduction.x mpich_uallreducef08.x \
     test_info.x

%.x: %.o ../source/libmpi_f08.a
	$(FC) $(FCFLAGS) $^ $(MPI_LIBS) -o $@

%.o: %.F90
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f *.x *.o
