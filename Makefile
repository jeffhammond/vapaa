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
	      mpi_comm_f.o mpi_comm_c.o mpi_comm.o \
	      mpi_datatype_f.o mpi_datatype_c.o mpi_datatype.o
	$(AR) $(ARFLAGS) $@ $^

mpi_f08.o: mpi_f08.F90 mpi_handle_types.o mpi_global_constants.o \
	   mpi_core_f.o mpi_comm_f.o mpi_datatype_f.o mpi_file_f.o \
	   mpi_group_f.o mpi_info_f.o mpi_message_f.o mpi_request_f.o \
	   mpi_win_f.o
	$(FC) $(FCFLAGS) -c $<

mpi_handle_types.o: mpi_handle_types.F90
	$(FC) $(FCFLAGS) -c $<

mpi_global_constants.o: mpi_global_constants.F90 mpi_handle_types.o
	$(FC) $(FCFLAGS) -c $<

# CORE

mpi_core_f.o: mpi_core_f.F90 mpi_handle_types.o mpi_global_constants.o \
              mpi_core_c.o mpi_comm_c.o  mpi_datatype_c.o
	$(FC) $(FCFLAGS) -c $<

mpi_core_c.o: mpi_core_c.F90 mpi_core.o
	$(FC) $(FCFLAGS) -c $<

mpi_core.o: mpi_core.c
	$(CC) $(CFLAGS) -c $<

# COMM

mpi_comm_f.o: mpi_comm_f.F90 mpi_comm_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_comm_c.o: mpi_comm_c.F90 mpi_comm.o
	$(FC) $(FCFLAGS) -c $<

mpi_comm.o: mpi_comm.c
	$(CC) $(CFLAGS) -c $<

# DATATYPE

mpi_datatype_f.o: mpi_datatype_f.F90 mpi_datatype_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_datatype_c.o: mpi_datatype_c.F90 mpi_datatype.o
	$(FC) $(FCFLAGS) -c $<

mpi_datatype.o: mpi_datatype.c
	$(CC) $(CFLAGS) -c $<

# FILE

mpi_file_f.o: mpi_file_f.F90 mpi_file_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_file_c.o: mpi_file_c.F90 mpi_file.o
	$(FC) $(FCFLAGS) -c $<

mpi_file.o: mpi_file.c
	$(CC) $(CFLAGS) -c $<

# GROUP

mpi_group_f.o: mpi_group_f.F90 mpi_group_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_group_c.o: mpi_group_c.F90 mpi_group.o
	$(FC) $(FCFLAGS) -c $<

mpi_group.o: mpi_group.c
	$(CC) $(CFLAGS) -c $<

# INFO

mpi_info_f.o: mpi_info_f.F90 mpi_info_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_info_c.o: mpi_info_c.F90 mpi_info.o
	$(FC) $(FCFLAGS) -c $<

mpi_info.o: mpi_info.c
	$(CC) $(CFLAGS) -c $<

# MESSAGE

mpi_message_f.o: mpi_message_f.F90 mpi_message_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_message_c.o: mpi_message_c.F90 mpi_message.o
	$(FC) $(FCFLAGS) -c $<

mpi_message.o: mpi_message.c
	$(CC) $(CFLAGS) -c $<

# REQUEST

mpi_request_f.o: mpi_request_f.F90 mpi_request_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_request_c.o: mpi_request_c.F90 mpi_request.o
	$(FC) $(FCFLAGS) -c $<

mpi_request.o: mpi_request.c
	$(CC) $(CFLAGS) -c $<

# WIN

mpi_win_f.o: mpi_win_f.F90 mpi_win_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_win_c.o: mpi_win_c.F90 mpi_win.o
	$(FC) $(FCFLAGS) -c $<

mpi_win.o: mpi_win.c
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
	-rm -f mpi_datatype_f.mod mpi_datatype_f.o
	-rm -f mpi_datatype_c.mod mpi_datatype_c.o
	-rm -f mpi_datatype.o
	-rm -f mpi_file_f.mod mpi_file_f.o
	-rm -f mpi_file_c.mod mpi_file_c.o
	-rm -f mpi_file.o
	-rm -f mpi_group_f.mod mpi_group_f.o
	-rm -f mpi_group_c.mod mpi_group_c.o
	-rm -f mpi_group.o
	-rm -f mpi_info_f.mod mpi_datatype_f.o
	-rm -f mpi_info_c.mod mpi_datatype_c.o
	-rm -f mpi_info.o
	-rm -f mpi_message_f.mod mpi_message_f.o
	-rm -f mpi_message_c.mod mpi_message_c.o
	-rm -f mpi_message.o
	-rm -f mpi_request_f.mod mpi_request_f.o
	-rm -f mpi_request_c.mod mpi_request_c.o
	-rm -f mpi_request.o
	-rm -f mpi_win_f.mod mpi_win_f.o
	-rm -f mpi_win_c.mod mpi_win_c.o
	-rm -f mpi_win.o
	-rm -f *.o *.mod
