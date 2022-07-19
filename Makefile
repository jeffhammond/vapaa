WARNFLAGS = -Wall -Wextra -Werror -pedantic

CC := mpicc
CFLAGS := -std=c11 $(WARNFLAGS)

FC := gfortran-11
FCFLAGS := -std=f2018 $(WARNFLAGS)

all: mpi_core.o mpi_core_c.o mpi_core_f.o

mpi_core.o: mpi_core.c
	$(CC) $(CFLAGS) -c $< -o $@

mpi_core_c.o mpi_core_c.mod: mpi_core_c.F90
	$(FC) $(FCFLAGS) -c $< -o $@

mpi_core_f.o mpi_core_f.mod: mpi_core_f.F90
	$(FC) $(FCFLAGS) -c $< -o $@

clean:
	-rm -f mpi_core.o
	-rm -f mpi_core_c.mod mpi_core_c.o
	-rm -f mpi_core_f.mod mpi_core_f.o
