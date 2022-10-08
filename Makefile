include make.inc

AR := ar
ARFLAGS := -r

all: test_core.x test_collectives.x test_reductions.x test_p2p.x test_cfi.x

test_cfi.x: test_cfi.F90 foo_cfi.c
	$(CC) $(CFLAGS) -c foo_cfi.c -o foo_cfi.o
	$(FC) $(FCFLAGS) test_cfi.F90 foo_cfi.o -o test_cfi.x

%.x: %.o libmpi_f08.a
	$(FC) $(FCFLAGS) $^ $(MPI_LIBS) -o $@
	#$(CC) $(CFLAGS) $^ $(FORTRAN_LIBS) -o $@

%.o: %.F90 mpi_f08.o
	$(FC) $(FCFLAGS) -c $<

libmpi_f08.a: mpi_f08.o mpi_handle_types.o mpi_global_constants.o \
	      mpi_core_f.o mpi_core_c.o mpi_core.o \
	      mpi_comm_f.o mpi_comm_c.o mpi_comm.o \
	      mpi_coll_f.o mpi_coll_c.o mpi_coll.o \
	      mpi_p2p_f.o mpi_p2p_c.o mpi_p2p.o \
	      mpi_datatype_f.o mpi_datatype_c.o mpi_datatype.o \
	      mpi_file_f.o mpi_file_c.o mpi_file.o \
	      mpi_group_f.o mpi_group_c.o mpi_group.o \
	      mpi_info_f.o mpi_info_c.o mpi_info.o \
	      mpi_message_f.o mpi_message_c.o mpi_message.o \
	      mpi_op_f.o mpi_op_c.o mpi_op.o \
	      mpi_request_f.o mpi_request_c.o mpi_request.o \
	      mpi_status_f.o mpi_status_c.o mpi_status.o \
	      mpi_win_f.o mpi_win_c.o mpi_win.o
	$(AR) $(ARFLAGS) $@ $^

mpi_f08.o: mpi_f08.F90 mpi_handle_types.o mpi_global_constants.o \
	   mpi_core_f.o mpi_comm_f.o mpi_coll_f.o mpi_datatype_f.o \
	   mpi_file_f.o mpi_group_f.o mpi_info_f.o mpi_message_f.o \
	   mpi_p2p_f.o mpi_op_f.o mpi_request_f.o mpi_status_f.o \
	   mpi_rma_f.o mpi_win_f.o
	$(FC) $(FCFLAGS) -c $<

mpi_handle_types.o: mpi_handle_types.F90
	$(FC) $(FCFLAGS) $(ABIFLAG) -c $<

mpi_global_constants.o: mpi_global_constants.F90 mpi_handle_types.o
	$(FC) $(FCFLAGS) -c $<

# CORE

mpi_core_f.o: mpi_core_f.F90 mpi_handle_types.o mpi_global_constants.o \
	      mpi_datatype_f.o mpi_op_f.o \
              mpi_core_c.o mpi_comm_c.o mpi_datatype_c.o mpi_file_c.o \
	      mpi_group_c.o mpi_info_c.o mpi_message_c.o mpi_op_c.o \
	      mpi_request_c.o mpi_status_c.o mpi_win_c.o
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

# COLLECTIVES

mpi_coll_f.o: mpi_coll_f.F90 mpi_coll_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_coll_c.o: mpi_coll_c.F90 mpi_coll.o
	$(FC) $(FCFLAGS) -c $<

mpi_coll.o: mpi_coll.c
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

# P2P

mpi_p2p_f.o: mpi_p2p_f.F90 mpi_p2p_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_p2p_c.o: mpi_p2p_c.F90 mpi_p2p.o
	$(FC) $(FCFLAGS) -c $<

mpi_p2p.o: mpi_p2p.c
	$(CC) $(CFLAGS) -c $<

# OP

mpi_op_f.o: mpi_op_f.F90 mpi_op_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_op_c.o: mpi_op_c.F90 mpi_op.o
	$(FC) $(FCFLAGS) -c $<

mpi_op.o: mpi_op.c
	$(CC) $(CFLAGS) -c $<

# REQUEST

mpi_request_f.o: mpi_request_f.F90 mpi_request_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_request_c.o: mpi_request_c.F90 mpi_request.o
	$(FC) $(FCFLAGS) -c $<

mpi_request.o: mpi_request.c
	$(CC) $(CFLAGS) -c $<

# status

mpi_status_f.o: mpi_status_f.F90 mpi_status_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_status_c.o: mpi_status_c.F90 mpi_status.o
	$(FC) $(FCFLAGS) -c $<

mpi_status.o: mpi_status.c
	$(CC) $(CFLAGS) -c $<

# RMA

mpi_rma_f.o: mpi_rma_f.F90 mpi_rma_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_rma_c.o: mpi_rma_c.F90 mpi_rma.o
	$(FC) $(FCFLAGS) -c $<

mpi_rma.o: mpi_rma.c
	$(CC) $(CFLAGS) -c $<

# WIN

mpi_win_f.o: mpi_win_f.F90 mpi_win_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_win_c.o: mpi_win_c.F90 mpi_win.o
	$(FC) $(FCFLAGS) -c $<

mpi_win.o: mpi_win.c
	$(CC) $(CFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f test_cfi.x test_cfi.o foo_cfi.o
	-rm -f test_core.x test_core.o
	-rm -f test_collectives.x test_collectives.o
	-rm -f test_reductions.x test_reductions.o
	-rm -f test_p2p.x test_p2p.o
	-rm -f libmpi_f08.a
	-rm -f mpi_f08.mod mpi_f08.o
	-rm -f mpi_handle_types.mod mpi_handle_types.o
	-rm -f mpi_global_constants.mod mpi_global_constants.o
	-rm -f mpi_comm_f.mod mpi_comm_f.o
	-rm -f mpi_comm_c.mod mpi_comm_c.o
	-rm -f mpi_comm.o
	-rm -f mpi_coll_f.mod mpi_coll_f.o
	-rm -f mpi_coll_c.mod mpi_coll_c.o
	-rm -f mpi_coll.o
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
	-rm -f mpi_info_f.mod mpi_info_f.o
	-rm -f mpi_info_c.mod mpi_info_c.o
	-rm -f mpi_info.o
	-rm -f mpi_message_f.mod mpi_message_f.o
	-rm -f mpi_message_c.mod mpi_message_c.o
	-rm -f mpi_message.o
	-rm -f mpi_op_f.mod mpi_op_f.o
	-rm -f mpi_op_c.mod mpi_op_c.o
	-rm -f mpi_op.o
	-rm -f mpi_p2p_f.mod mpi_p2p_f.o
	-rm -f mpi_p2p_c.mod mpi_p2p_c.o
	-rm -f mpi_p2p.o
	-rm -f mpi_request_f.mod mpi_request_f.o
	-rm -f mpi_request_c.mod mpi_request_c.o
	-rm -f mpi_request.o
	-rm -f mpi_rma_f.mod mpi_rma_f.o
	-rm -f mpi_rma_c.mod mpi_rma_c.o
	-rm -f mpi_rma.o
	-rm -f mpi_status_f.mod mpi_status_f.o
	-rm -f mpi_status_c.mod mpi_status_c.o
	-rm -f mpi_status.o
	-rm -f mpi_win_f.mod mpi_win_f.o
	-rm -f mpi_win_c.mod mpi_win_c.o
	-rm -f mpi_win.o
