include ../make.inc

AR := ar
ARFLAGS := -r

# obviously, you have to compile in ../source first
FCFLAGS += -I../source -L../source -lmpi_f08

FCFLAGS += -Wno-unused-variable -Wno-unused-dummy-argument \
	   -fmax-stack-var-size=1000000

all: test_core.x test_bcast.x test_reductions.x test_p2p.x \
     test_thread.x test_file.x test_file_error.x test_handles.x \
     test_vector_noncontig.x test_matrix_noncontig.x test_tensor_noncontig.x \
     test_matrix_noncontig_2.x test_matrix_noncontig_3.x \
     test_datatype.x test_comm.x test_user_reduction.x mpich_uallreducef08.x \
     test_info.x test_error.x test_reduce_ops.x test_reduce_mxxloc.x \
     test_serialization.x test_serialization_2.x test_attr.x

%.x: %.o ../source/libmpi_f08.a
	$(FC) $(FCFLAGS) $^ $(MPI_LIBS) -o $@

%.o: %.F90
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f *.x *.o *.mod
