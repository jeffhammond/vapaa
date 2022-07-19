WARNFLAGS = -Wall -Wextra -Werror -pedantic

CC := mpicc
CFLAGS := -std=c11 $(WARNFLAGS)

FC := gfortran-11
FCFLAGS := -std=f2018 $(WARNFLAGS)

FORTRAN_LIBS = -L/opt/homebrew/Cellar/gcc/11.3.0_2/lib/gcc/11 -lgfortran

all: test_core.x

test_core.x: test_core.o mpi_core_f.o mpi_core_c.o mpi_core.o
	$(CC) $(CFLAGS) $^ $(FORTRAN_LIBS) -o $@

test_core.o: test_core.F90 mpi_core_f.o mpi_core_c.o
	$(FC) $(FCFLAGS) -c $< -o $@

mpi_core.o: mpi_core.c
	$(CC) $(CFLAGS) -c $< -o $@

mpi_core_c.o: mpi_core_c.F90 mpi_core.o
	$(FC) $(FCFLAGS) -c $< -o $@

mpi_core_f.o: mpi_core_f.F90 mpi_core_c.o
	$(FC) $(FCFLAGS) -c $< -o $@

clean:
	-rm -f test_core.x test_core.o
	-rm -f mpi_core.o
	-rm -f mpi_core_c.mod mpi_core_c.o
	-rm -f mpi_core_f.mod mpi_core_f.o
