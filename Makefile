WARNFLAGS = -Wall -Wextra -Werror -pedantic

CC := mpicc
CFLAGS := -std=c11 $(WARNFLAGS)

FC := gfortran-11
FCFLAGS := -std=f2018 $(WARNFLAGS)

AR := ar
ARFLAGS := -r

FORTRAN_LIBS = -L/opt/homebrew/Cellar/gcc/11.3.0_2/lib/gcc/11 -lgfortran

all: test_core.x

test_core.x: test_core.o libmpi_f08.a
	$(CC) $(CFLAGS) $^ $(FORTRAN_LIBS) -o $@

test_core.o: test_core.F90 mpi_f08.o
	$(FC) $(FCFLAGS) -c $<

libmpi_f08.a: mpi_f08.o mpi_handle_types.o mpi_global_constants.o \
	      mpi_core_f.o mpi_core_c.o mpi_core.o \
	      mpi_comm_f.o mpi_comm_c.o mpi_comm.o
	$(AR) $(ARFLAGS) $@ $^

mpi_f08.o: mpi_f08.F90 mpi_handle_types.o mpi_global_constants.o \
	   mpi_core_f.o mpi_comm_f.o
	$(FC) $(FCFLAGS) -c $<

mpi_handle_types.o: mpi_handle_types.F90
	$(FC) $(FCFLAGS) -c $<

mpi_global_constants.o: mpi_global_constants.F90 mpi_handle_types.o
	$(FC) $(FCFLAGS) -c $<

mpi_core_f.o: mpi_core_f.F90 mpi_core_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_core_c.o: mpi_core_c.F90 mpi_core.o
	$(FC) $(FCFLAGS) -c $<

mpi_core.o: mpi_core.c
	$(CC) $(CFLAGS) -c $<

mpi_comm_f.o: mpi_comm_f.F90 mpi_comm_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_comm_c.o: mpi_comm_c.F90 mpi_comm.o
	$(FC) $(FCFLAGS) -c $<

mpi_comm.o: mpi_comm.c
	$(CC) $(CFLAGS) -c $<

clean:
	-rm -f test_core.x test_core.o
	-rm -f libmpi_f08.a
	-rm -f mpi_f08.mod mpi_f08.o
	-rm -f mpi_handle_types.mod mpi_handle_types.o
	-rm -f mpi_global_constants.mod mpi_global_constants.o
	-rm -f mpi_comm_f.mod mpi_comm_f.o
	-rm -f mpi_comm_c.mod mpi_comm_c.o
	-rm -f mpi_comm.o
	-rm -f mpi_core_f.mod mpi_core_f.o
	-rm -f mpi_core_c.mod mpi_core_c.o
	-rm -f mpi_core.o
