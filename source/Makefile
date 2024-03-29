include ../make.inc

AR := ar
ARFLAGS := -r

all: libmpi_f08.a

%.o: %.F90 mpi_f08.o
	$(FC) $(FCFLAGS) -c $<

libmpi_f08.a: mpi_f08.o cfi_util.o debug.o \
	      detect_sentinels.o detect_sentinels_c.o \
	      mpi_global_constants.o \
	      mpi_handle_types.o mpi_handle_operators.o \
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
	      mpi_win_f.o mpi_win_c.o mpi_win.o \
	      mpi_attr_f.o mpi_attr_c.o mpi_attr.o \
	      mpi_error_f.o mpi_error_c.o mpi_error.o
	$(AR) $(ARFLAGS) $@ $^

mpi_f08.o: mpi_f08.F90 \
	   detect_sentinels_c.o \
	   mpi_global_constants.o \
	   mpi_handle_types.o mpi_handle_operators.o \
	   mpi_core_f.o mpi_comm_f.o mpi_coll_f.o mpi_datatype_f.o \
	   mpi_file_f.o mpi_group_f.o mpi_info_f.o mpi_message_f.o \
	   mpi_file_f.o mpi_group_f.o mpi_info_f.o mpi_message_f.o \
	   mpi_p2p_f.o mpi_op_f.o mpi_request_f.o mpi_status_f.o \
	   mpi_rma_f.o mpi_win_f.o mpi_attr_f.o mpi_error_f.o
	$(FC) $(FCFLAGS) -c $<

debug.o: debug.c debug.h
	$(CC) $(CFLAGS) -c $<

cfi_util.o: cfi_util.c cfi_util.h
	$(CC) $(CFLAGS) -c $<

detect_sentinels.o: detect_sentinels.c
	$(CC) $(CFLAGS) -c $<

detect_sentinels_c.o: detect_sentinels_c.F90
	$(FC) $(FCFLAGS) $(ABIFLAG) -c $<

mpi_handle_types.o: mpi_handle_types.F90
	$(FC) $(FCFLAGS) $(ABIFLAG) -c $<

mpi_handle_operators.o: mpi_handle_operators.F90 mpi_handle_types.o
	$(FC) $(FCFLAGS) -c $<

mpi_global_constants.o: mpi_global_constants.F90 mpi_handle_types.o vapaa_constants.h
	$(FC) $(FCFLAGS) -c $<

# CORE

mpi_core_f.o: mpi_core_f.F90 mpi_handle_types.o mpi_global_constants.o detect_sentinels_c.o \
	      mpi_datatype_f.o mpi_op_f.o mpi_status_f.o \
              mpi_core_c.o mpi_comm_c.o mpi_datatype_c.o mpi_file_c.o \
	      mpi_group_c.o mpi_info_c.o mpi_message_c.o mpi_op_c.o \
	      mpi_request_c.o mpi_status_c.o mpi_win_c.o
	$(FC) $(FCFLAGS) -c $<

mpi_core_c.o: mpi_core_c.F90 mpi_core.o
	$(FC) $(FCFLAGS) -c $<

mpi_core.o: mpi_core.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# COMM

mpi_comm_f.o: mpi_comm_f.F90 mpi_comm_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_comm_c.o: mpi_comm_c.F90 mpi_comm.o
	$(FC) $(FCFLAGS) -c $<

mpi_comm.o: mpi_comm.c convert_handles.h convert_constants.h detect_builtins.h cfi_util.h
	$(CC) $(CFLAGS) -c $<

# COLLECTIVES

mpi_coll_f.o: mpi_coll_f.F90 mpi_coll_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_coll_c.o: mpi_coll_c.F90 mpi_coll.o detect_sentinels.h
	$(FC) $(FCFLAGS) -c $<

mpi_coll.o: mpi_coll.c convert_handles.h convert_constants.h detect_builtins.h cfi_util.h
	$(CC) $(CFLAGS) -c $<

# DATATYPE

mpi_datatype_f.o: mpi_datatype_f.F90 mpi_datatype_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_datatype_c.o: mpi_datatype_c.F90 mpi_datatype.o
	$(FC) $(FCFLAGS) -c $<

mpi_datatype.o: mpi_datatype.c convert_handles.h convert_constants.h vapaa_constants.h
	$(CC) $(CFLAGS) -c $<

# FILE

mpi_file_f.o: mpi_file_f.F90 mpi_file_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_file_c.o: mpi_file_c.F90 mpi_file.o mpi_handle_types.o detect_sentinels.h
	$(FC) $(FCFLAGS) -c $<

mpi_file.o: mpi_file.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# GROUP

mpi_group_f.o: mpi_group_f.F90 mpi_group_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_group_c.o: mpi_group_c.F90 mpi_group.o
	$(FC) $(FCFLAGS) -c $<

mpi_group.o: mpi_group.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# INFO

mpi_info_f.o: mpi_info_f.F90 mpi_info_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_info_c.o: mpi_info_c.F90 mpi_info.o
	$(FC) $(FCFLAGS) -c $<

mpi_info.o: mpi_info.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# MESSAGE

mpi_message_f.o: mpi_message_f.F90 mpi_message_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_message_c.o: mpi_message_c.F90 mpi_message.o
	$(FC) $(FCFLAGS) -c $<

mpi_message.o: mpi_message.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# P2P

mpi_p2p_f.o: mpi_p2p_f.F90 mpi_p2p_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_p2p_c.o: mpi_p2p_c.F90 mpi_p2p.o mpi_handle_types.o
	$(FC) $(FCFLAGS) -c $<

mpi_p2p.o: mpi_p2p.c convert_handles.h convert_constants.h detect_sentinels.h
	$(CC) $(CFLAGS) -c $<

# OP

mpi_op_f.o: mpi_op_f.F90 mpi_op_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_op_c.o: mpi_op_c.F90 mpi_op.o
	$(FC) $(FCFLAGS) -c $<

mpi_op.o: mpi_op.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# REQUEST

mpi_request_f.o: mpi_request_f.F90 mpi_request_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_request_c.o: mpi_request_c.F90 mpi_request.o mpi_handle_types.o
	$(FC) $(FCFLAGS) -c $<

mpi_request.o: mpi_request.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# status

mpi_status_f.o: mpi_status_f.F90 mpi_status_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_status_c.o: mpi_status_c.F90 mpi_status.o mpi_handle_types.o
	$(FC) $(FCFLAGS) -c $<

mpi_status.o: mpi_status.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# RMA

mpi_rma_f.o: mpi_rma_f.F90 mpi_rma_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_rma_c.o: mpi_rma_c.F90 mpi_rma.o
	$(FC) $(FCFLAGS) -c $<

mpi_rma.o: mpi_rma.c convert_handles.h convert_constants.h detect_sentinels.h
	$(CC) $(CFLAGS) -c $<

# WIN

mpi_win_f.o: mpi_win_f.F90 mpi_win_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_win_c.o: mpi_win_c.F90 mpi_win.o
	$(FC) $(FCFLAGS) -c $<

mpi_win.o: mpi_win.c convert_handles.h convert_constants.h
	$(CC) $(CFLAGS) -c $<

# ERROR

mpi_error_f.o: mpi_error_f.F90 mpi_error_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_error_c.o: mpi_error_c.F90 mpi_error.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_error.o: mpi_error.c convert_handles.h convert_constants.h vapaa_constants.h
	$(CC) $(CFLAGS) -c $<

# ATTRIBUTES

mpi_attr_f.o: mpi_attr_f.F90 mpi_attr_c.o mpi_handle_types.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_attr_c.o: mpi_attr_c.F90 mpi_attr.o mpi_global_constants.o
	$(FC) $(FCFLAGS) -c $<

mpi_attr.o: mpi_attr.c convert_handles.h convert_constants.h vapaa_constants.h
	$(CC) $(CFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f libmpi_f08.a *.mod *.o
