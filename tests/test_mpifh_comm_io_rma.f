      program test_mpifh_comm_io_rma
      implicit none
      include 'mpif.h'
      integer ierr, errors, rank, nproc

      errors = 0
      call MPI_Init(ierr)
      call check_success(ierr, errors)
      call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_set_errhandler(MPI_COMM_WORLD, MPI_ERRORS_RETURN,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_Comm_set_errhandler(MPI_COMM_SELF, MPI_ERRORS_RETURN,
     &     ierr)
      call check_success(ierr, errors)

      call cover_comm(errors)
      call cover_topology(rank, nproc, errors)
      call cover_collectives(rank, nproc, errors)
      call cover_file(rank, errors)
      call cover_rma(rank, errors)

      call MPI_Finalize(ierr)
      call check_success(ierr, errors)

      if (errors .eq. 0) then
          if (rank .eq. 0) print *, 'Test passed'
      else
          print *, 'Test failed on rank ', rank, ' with ', errors,
     &             ' errors'
          stop 1
      endif
      end

      subroutine cover_comm(errors)
      implicit none
      include 'mpif.h'
      integer errors
      integer ierr, info, comm2, comm3, req, status(MPI_STATUS_SIZE)
      integer group, parent, flag, result
      character*32 name
      character*64 port

      call MPI_Info_create(info, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_get_info(MPI_COMM_WORLD, info, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_set_info(MPI_COMM_WORLD, info, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_dup_with_info(MPI_COMM_WORLD, info, comm2, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_compare(MPI_COMM_WORLD, comm2, result, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_free(comm2, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_idup(MPI_COMM_WORLD, comm2, req, ierr)
      call check_success(ierr, errors)
      call MPI_Wait(req, status, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_free(comm2, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_idup_with_info(MPI_COMM_WORLD, info, comm2, req,
     &     ierr)
      call finish_request(req, ierr, errors)
      if (ierr .eq. MPI_SUCCESS) then
          call MPI_Comm_free(comm2, ierr)
          call check_success(ierr, errors)
      endif

      call MPI_Comm_group(MPI_COMM_WORLD, group, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_create_group(MPI_COMM_WORLD, group, 7, comm3,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_Comm_free(comm3, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_create(MPI_COMM_WORLD, group, comm3, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_free(comm3, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(group, ierr)
      call check_success(ierr, errors)

      call MPI_Comm_test_inter(MPI_COMM_WORLD, flag, ierr)
      call check_success(ierr, errors)
      if (flag .ne. 0) errors = errors + 1
      call MPI_Comm_get_parent(parent, ierr)
      call check_success(ierr, errors)
      if (parent .ne. MPI_COMM_NULL) errors = errors + 1

      name = 'vapaa-mpifh-world'
      call MPI_Comm_set_name(MPI_COMM_WORLD, name, ierr)
      call check_success(ierr, errors)
      name = ' '
      call MPI_Comm_get_name(MPI_COMM_WORLD, name, result, ierr)
      call check_success(ierr, errors)

      port = ' '
      call MPI_Open_port(MPI_INFO_NULL, port, ierr)
      call check_success_or_unsupported(ierr, errors)
      if (ierr .eq. MPI_SUCCESS) then
          call MPI_Close_port(port, ierr)
          call check_success(ierr, errors)
      endif

      call MPI_Info_free(info, ierr)
      call check_success(ierr, errors)
      end

      subroutine cover_topology(rank, nproc, errors)
      implicit none
      include 'mpif.h'
      integer rank, nproc, errors
      integer ierr, cart, subcart, graph, ndims, topo, newrank
      integer dims(1), coords(1), periods(1), remain(1)
      integer index(4), edges(8), nneigh, neighbors(2)
      integer nnodes, nedges, i

      dims(1) = nproc
      periods(1) = 1
      call MPI_Cart_create(MPI_COMM_WORLD, 1, dims, periods, 0, cart,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_Cartdim_get(cart, ndims, ierr)
      call check_success(ierr, errors)
      call MPI_Cart_coords(cart, rank, 1, coords, ierr)
      call check_success(ierr, errors)
      call MPI_Cart_rank(cart, coords, newrank, ierr)
      call check_success(ierr, errors)
      if (newrank .ne. rank) errors = errors + 1
      call MPI_Cart_map(MPI_COMM_WORLD, 1, dims, periods, newrank, ierr)
      call check_success(ierr, errors)
      remain(1) = 1
      call MPI_Cart_sub(cart, remain, subcart, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_free(subcart, ierr)
      call check_success(ierr, errors)
      call MPI_Topo_test(cart, topo, ierr)
      call check_success(ierr, errors)
      call MPI_Comm_free(cart, ierr)
      call check_success(ierr, errors)

      do i = 1, nproc
          index(i) = 2 * i
          edges(2*i-1) = mod(i - 2 + nproc, nproc)
          edges(2*i) = mod(i, nproc)
      enddo
      call MPI_Graph_create(MPI_COMM_WORLD, nproc, index, edges, 0,
     &     graph, ierr)
      call check_success(ierr, errors)
      call MPI_Graphdims_get(graph, nnodes, nedges, ierr)
      call check_success(ierr, errors)
      call MPI_Graph_neighbors_count(graph, rank, nneigh, ierr)
      call check_success(ierr, errors)
      call MPI_Graph_neighbors(graph, rank, 2, neighbors, ierr)
      call check_success(ierr, errors)
      call MPI_Graph_get(graph, 4, 8, index, edges, ierr)
      call check_success(ierr, errors)
      call MPI_Graph_map(MPI_COMM_WORLD, nproc, index, edges, newrank,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_Comm_free(graph, ierr)
      call check_success(ierr, errors)
      end

      subroutine cover_collectives(rank, nproc, errors)
      implicit none
      include 'mpif.h'
      integer rank, nproc, errors
      integer ierr, req, cart
      integer send1, recv1, sendv(4), recvv(4), counts(4), displs(4)
      integer types(4), bdispls(4), i, bytes, sum
      integer dims(1), periods(1)
      integer nsend(2), nrecv(2), ncounts(2), ndispls(2), ntypes(2)
      integer(kind=MPI_ADDRESS_KIND) nadispls(2)

      call fill_counts4(counts, displs)
      bytes = storage_size(send1) / 8
      do i = 1, 4
          bdispls(i) = (i - 1) * bytes
          types(i) = MPI_INTEGER
      enddo
      sum = (nproc * (nproc + 1)) / 2
      send1 = rank + 1

      call MPI_Allgather(send1, 1, MPI_INTEGER, recvv, 1,
     &     MPI_INTEGER, MPI_COMM_WORLD, ierr)
      call check_success(ierr, errors)
      call MPI_Allgatherv(send1, 1, MPI_INTEGER, recvv, counts,
     &     displs, MPI_INTEGER, MPI_COMM_WORLD, ierr)
      call check_success(ierr, errors)
      call MPI_Iallgather(send1, 1, MPI_INTEGER, recvv, 1,
     &     MPI_INTEGER, MPI_COMM_WORLD, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Iallgatherv(send1, 1, MPI_INTEGER, recvv, counts,
     &     displs, MPI_INTEGER, MPI_COMM_WORLD, req, ierr)
      call finish_request(req, ierr, errors)

      do i = 1, 4
          sendv(i) = rank * 10 + i
      enddo
      call MPI_Iscatter(sendv, 1, MPI_INTEGER, recv1, 1, MPI_INTEGER,
     &     0, MPI_COMM_WORLD, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Iscatterv(sendv, counts, displs, MPI_INTEGER, recv1, 1,
     &     MPI_INTEGER, 0, MPI_COMM_WORLD, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Ialltoallv(sendv, counts, displs, MPI_INTEGER, recvv,
     &     counts, displs, MPI_INTEGER, MPI_COMM_WORLD, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Ialltoallw(sendv, counts, bdispls, types, recvv,
     &     counts, bdispls, types, MPI_COMM_WORLD, req, ierr)
      call finish_request(req, ierr, errors)

      sendv = rank + 1
      call MPI_Ireduce_scatter(sendv, recv1, counts, MPI_INTEGER,
     &     MPI_SUM, MPI_COMM_WORLD, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Ireduce_scatter_block(sendv, recv1, 1, MPI_INTEGER,
     &     MPI_SUM, MPI_COMM_WORLD, req, ierr)
      call finish_request(req, ierr, errors)

      call MPI_Barrier_init(MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
      call finish_persistent(req, ierr, errors)
      call MPI_Bcast_init(send1, 1, MPI_INTEGER, 0, MPI_COMM_WORLD,
     &     MPI_INFO_NULL, req, ierr)
      call finish_persistent(req, ierr, errors)
      call MPI_Allreduce_init(send1, recv1, 1, MPI_INTEGER, MPI_SUM,
     &     MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
      call finish_persistent(req, ierr, errors)
      call MPI_Reduce_init(send1, recv1, 1, MPI_INTEGER, MPI_SUM, 0,
     &     MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
      call finish_persistent(req, ierr, errors)
      call MPI_Scan_init(send1, recv1, 1, MPI_INTEGER, MPI_SUM,
     &     MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
      call finish_persistent(req, ierr, errors)
      call MPI_Exscan_init(send1, recv1, 1, MPI_INTEGER, MPI_SUM,
     &     MPI_COMM_WORLD, MPI_INFO_NULL, req, ierr)
      call finish_persistent(req, ierr, errors)
      call MPI_Alltoallw_init(sendv, counts, bdispls, types, recvv,
     &     counts, bdispls, types, MPI_COMM_WORLD, MPI_INFO_NULL, req,
     &     ierr)
      call finish_persistent(req, ierr, errors)

      dims(1) = nproc
      periods(1) = 1
      call MPI_Cart_create(MPI_COMM_WORLD, 1, dims, periods, 0, cart,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_Comm_set_errhandler(cart, MPI_ERRORS_RETURN, ierr)
      call check_success(ierr, errors)
      nsend(1) = rank * 10 + 1
      nsend(2) = rank * 10 + 2
      ncounts(1) = 1
      ncounts(2) = 1
      ndispls(1) = 0
      ndispls(2) = 1
      nadispls(1) = 0
      nadispls(2) = bytes
      ntypes(1) = MPI_INTEGER
      ntypes(2) = MPI_INTEGER
      call MPI_Neighbor_allgather(send1, 1, MPI_INTEGER, nrecv, 1,
     &     MPI_INTEGER, cart, ierr)
      call check_success(ierr, errors)
      call MPI_Neighbor_allgatherv(send1, 1, MPI_INTEGER, nrecv,
     &     ncounts, ndispls, MPI_INTEGER, cart, ierr)
      call check_success(ierr, errors)
      call MPI_Neighbor_alltoall(nsend, 1, MPI_INTEGER, nrecv, 1,
     &     MPI_INTEGER, cart, ierr)
      call check_success(ierr, errors)
      call MPI_Neighbor_alltoallv(nsend, ncounts, ndispls, MPI_INTEGER,
     &     nrecv, ncounts, ndispls, MPI_INTEGER, cart, ierr)
      call check_success(ierr, errors)
      call MPI_Neighbor_alltoallw(nsend, ncounts, nadispls, ntypes,
     &     nrecv, ncounts, nadispls, ntypes, cart, ierr)
      call check_success(ierr, errors)
      call MPI_Ineighbor_allgather(send1, 1, MPI_INTEGER, nrecv, 1,
     &     MPI_INTEGER, cart, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Ineighbor_allgatherv(send1, 1, MPI_INTEGER, nrecv,
     &     ncounts, ndispls, MPI_INTEGER, cart, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Ineighbor_alltoall(nsend, 1, MPI_INTEGER, nrecv, 1,
     &     MPI_INTEGER, cart, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Ineighbor_alltoallv(nsend, ncounts, ndispls,
     &     MPI_INTEGER, nrecv, ncounts, ndispls, MPI_INTEGER, cart,
     &     req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Ineighbor_alltoallw(nsend, ncounts, nadispls, ntypes,
     &     nrecv, ncounts, nadispls, ntypes, cart, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Neighbor_allgather_init(send1, 1, MPI_INTEGER, nrecv,
     &     1, MPI_INTEGER, cart, MPI_INFO_NULL, req, ierr)
      call finish_persistent(req, ierr, errors)
      call MPI_Neighbor_alltoallw_init(nsend, ncounts, nadispls,
     &     ntypes, nrecv, ncounts, nadispls, ntypes, cart,
     &     MPI_INFO_NULL, req, ierr)
      call finish_persistent(req, ierr, errors)
      call MPI_Comm_free(cart, ierr)
      call check_success(ierr, errors)
      end

      subroutine cover_file(rank, errors)
      implicit none
      include 'mpif.h'
      integer rank, errors
      integer ierr, fh, amode, status(MPI_STATUS_SIZE), req
      integer buf(4), got(4), count, flag, group, info, etype, ftype
      integer errh, slen
      integer(kind=MPI_OFFSET_KIND) offset, fsize, disp
      integer(kind=MPI_ADDRESS_KIND) extent
      character*64 filename
      character*16 datarep

      write(filename, '(A,I4.4,A)') 'mpifh_more_', rank, '.dat'
      amode = MPI_MODE_CREATE + MPI_MODE_RDWR +
     &        MPI_MODE_DELETE_ON_CLOSE
      call MPI_File_open(MPI_COMM_SELF, filename, amode, MPI_INFO_NULL,
     &     fh, ierr)
      call check_success(ierr, errors)
      call MPI_File_set_errhandler(fh, MPI_ERRORS_RETURN, ierr)
      call check_success(ierr, errors)
      buf(1) = rank + 100
      buf(2) = rank + 200
      buf(3) = rank + 300
      buf(4) = rank + 400
      got = -1
      count = 4
      offset = 0
      call MPI_File_write_at(fh, offset, buf, count, MPI_INTEGER,
     &     status, ierr)
      call check_success(ierr, errors)
      call MPI_File_read_at(fh, offset, got, count, MPI_INTEGER,
     &     status, ierr)
      call check_success(ierr, errors)
      call MPI_File_seek(fh, offset, MPI_SEEK_SET, ierr)
      call check_success(ierr, errors)
      call MPI_File_write(fh, buf, count, MPI_INTEGER, status, ierr)
      call check_success(ierr, errors)
      call MPI_File_seek(fh, offset, MPI_SEEK_SET, ierr)
      call check_success(ierr, errors)
      got = -1
      call MPI_File_read(fh, got, count, MPI_INTEGER, status, ierr)
      call check_success(ierr, errors)
      call MPI_File_write_all(fh, buf, count, MPI_INTEGER, status,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_File_read_all(fh, got, count, MPI_INTEGER, status,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_File_write_at_all(fh, offset, buf, count, MPI_INTEGER,
     &     status, ierr)
      call check_success(ierr, errors)
      call MPI_File_read_at_all(fh, offset, got, count, MPI_INTEGER,
     &     status, ierr)
      call check_success(ierr, errors)
      call MPI_File_iwrite_at(fh, offset, buf, count, MPI_INTEGER,
     &     req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_File_iread_at(fh, offset, got, count, MPI_INTEGER,
     &     req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_File_write_shared(fh, buf, count, MPI_INTEGER, status,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_File_seek_shared(fh, offset, MPI_SEEK_SET, ierr)
      call check_success(ierr, errors)
      call MPI_File_read_shared(fh, got, count, MPI_INTEGER, status,
     &     ierr)
      call check_success(ierr, errors)
      call MPI_File_get_position(fh, offset, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_position_shared(fh, offset, ierr)
      call check_success(ierr, errors)
      fsize = 128
      call MPI_File_preallocate(fh, fsize, ierr)
      call check_success(ierr, errors)
      call MPI_File_set_size(fh, fsize, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_size(fh, fsize, ierr)
      call check_success(ierr, errors)
      disp = 0
      call MPI_File_set_view(fh, disp, MPI_INTEGER, MPI_INTEGER,
     &     'native', MPI_INFO_NULL, ierr)
      call check_success(ierr, errors)
      datarep = ' '
      call MPI_File_get_view(fh, disp, etype, ftype, datarep, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_type_extent(fh, MPI_INTEGER, extent, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_group(fh, group, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(group, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_info(fh, info, ierr)
      call check_success(ierr, errors)
      call MPI_Info_free(info, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_amode(fh, amode, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_atomicity(fh, flag, ierr)
      call check_success(ierr, errors)
      flag = 1
      call MPI_File_set_atomicity(fh, flag, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_byte_offset(fh, offset, disp, ierr)
      call check_success(ierr, errors)
      call MPI_File_get_errhandler(fh, errh, ierr)
      call check_success(ierr, errors)
      call MPI_Errhandler_free(errh, ierr)
      call check_success(ierr, errors)
      call MPI_File_sync(fh, ierr)
      call check_success(ierr, errors)
      call MPI_File_call_errhandler(fh, MPI_SUCCESS, ierr)
      call check_success(ierr, errors)
      call MPI_File_close(fh, ierr)
      call check_success(ierr, errors)
      call MPI_File_delete(filename, MPI_INFO_NULL, ierr)
      if (ierr .ne. MPI_SUCCESS) ierr = MPI_SUCCESS
      slen = 0
      end

      subroutine cover_rma(rank, errors)
      implicit none
      include 'mpif.h'
      integer rank, errors
      integer ierr, win, req, group, info
      integer winbuf(4), origin, result, compare, flag, disp_unit
      integer errh, keyval
      integer(kind=MPI_ADDRESS_KIND) winsize, disp, attr
      character*32 name

      winbuf = 0
      winsize = 4 * (storage_size(winbuf(1)) / 8)
      disp_unit = storage_size(winbuf(1)) / 8
      call MPI_Win_create(winbuf, winsize, disp_unit, MPI_INFO_NULL,
     &     MPI_COMM_SELF, win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_set_errhandler(win, MPI_ERRORS_RETURN, ierr)
      call check_success(ierr, errors)
      name = 'mpifh-window'
      call MPI_Win_set_name(win, name, ierr)
      call check_success(ierr, errors)
      name = ' '
      call MPI_Win_get_name(win, name, flag, ierr)
      call check_success(ierr, errors)
      call MPI_Win_get_group(win, group, ierr)
      call check_success(ierr, errors)
      call MPI_Win_get_info(win, info, ierr)
      call check_success(ierr, errors)
      call MPI_Info_free(info, ierr)
      call check_success(ierr, errors)
      call MPI_Win_get_errhandler(win, errh, ierr)
      call check_success(ierr, errors)
      call MPI_Errhandler_free(errh, ierr)
      call check_success(ierr, errors)

      disp = 0
      origin = rank + 5
      result = -1
      compare = 0
      call MPI_Win_lock(MPI_LOCK_EXCLUSIVE, 0, 0, win, ierr)
      call check_success(ierr, errors)
      call MPI_Put(origin, 1, MPI_INTEGER, 0, disp, 1, MPI_INTEGER,
     &     win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_flush(0, win, ierr)
      call check_success(ierr, errors)
      call MPI_Get(result, 1, MPI_INTEGER, 0, disp, 1, MPI_INTEGER,
     &     win, ierr)
      call check_success(ierr, errors)
      call MPI_Accumulate(origin, 1, MPI_INTEGER, 0, disp, 1,
     &     MPI_INTEGER, MPI_SUM, win, ierr)
      call check_success(ierr, errors)
      call MPI_Get_accumulate(origin, 1, MPI_INTEGER, result, 1,
     &     MPI_INTEGER, 0, disp, 1, MPI_INTEGER, MPI_SUM, win, ierr)
      call check_success(ierr, errors)
      call MPI_Fetch_and_op(origin, result, MPI_INTEGER, 0, disp,
     &     MPI_REPLACE, win, ierr)
      call check_success(ierr, errors)
      call MPI_Compare_and_swap(origin, compare, result, MPI_INTEGER,
     &     0, disp, win, ierr)
      call check_success(ierr, errors)
      call MPI_Rput(origin, 1, MPI_INTEGER, 0, disp, 1, MPI_INTEGER,
     &     win, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Rget(result, 1, MPI_INTEGER, 0, disp, 1, MPI_INTEGER,
     &     win, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Raccumulate(origin, 1, MPI_INTEGER, 0, disp, 1,
     &     MPI_INTEGER, MPI_SUM, win, req, ierr)
      call finish_request(req, ierr, errors)
      call MPI_Rget_accumulate(origin, 1, MPI_INTEGER, result, 1,
     &     MPI_INTEGER, 0, disp, 1, MPI_INTEGER, MPI_SUM, win, req,
     &     ierr)
      call finish_request(req, ierr, errors)
      call MPI_Win_flush_local(0, win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_unlock(0, win, ierr)
      call check_success(ierr, errors)

      call MPI_Win_lock_all(0, win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_flush_all(win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_flush_local_all(win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_unlock_all(win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_fence(0, win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_fence(0, win, ierr)
      call check_success(ierr, errors)
      call MPI_Win_sync(win, ierr)
      call check_success_or_unsupported(ierr, errors)
      call MPI_Win_create_keyval(MPI_WIN_NULL_COPY_FN,
     &     MPI_WIN_NULL_DELETE_FN, keyval, 0_MPI_ADDRESS_KIND, ierr)
      call check_success(ierr, errors)
      attr = 42
      call MPI_Win_set_attr(win, keyval, attr, ierr)
      call check_success(ierr, errors)
      attr = 0
      call MPI_Win_get_attr(win, keyval, attr, flag, ierr)
      call check_success(ierr, errors)
      call MPI_Win_delete_attr(win, keyval, ierr)
      call check_success(ierr, errors)
      call MPI_Win_free_keyval(keyval, ierr)
      call check_success(ierr, errors)
      call MPI_Group_free(group, ierr)
      call check_success(ierr, errors)
      call MPI_Win_free(win, ierr)
      call check_success(ierr, errors)
      end

      subroutine fill_counts4(counts, displs)
      implicit none
      integer counts(4), displs(4), i
      do i = 1, 4
          counts(i) = 1
          displs(i) = i - 1
      enddo
      end

      subroutine finish_request(request, ierr, errors)
      implicit none
      include 'mpif.h'
      integer request, ierr, errors, status(MPI_STATUS_SIZE)
      if (ierr .eq. MPI_SUCCESS) then
          call MPI_Wait(request, status, ierr)
          call check_success(ierr, errors)
      else
          call check_success_or_unsupported(ierr, errors)
      endif
      end

      subroutine finish_persistent(request, ierr, errors)
      implicit none
      include 'mpif.h'
      integer request, ierr, errors, status(MPI_STATUS_SIZE)
      if (ierr .eq. MPI_SUCCESS) then
          call MPI_Start(request, ierr)
          call check_success(ierr, errors)
          call MPI_Wait(request, status, ierr)
          call check_success(ierr, errors)
          call MPI_Request_free(request, ierr)
          call check_success(ierr, errors)
      else
          call check_success_or_unsupported(ierr, errors)
      endif
      end

      subroutine check_success(ierr, errors)
      implicit none
      include 'mpif.h'
      integer ierr, errors
      if (ierr .ne. MPI_SUCCESS) errors = errors + 1
      end

      subroutine check_success_or_unsupported(ierr, errors)
      implicit none
      include 'mpif.h'
      integer ierr, errors
      if (ierr .ne. MPI_SUCCESS .and.
     &    ierr .ne. MPI_ERR_UNSUPPORTED_OPERATION) errors = errors + 1
      end
