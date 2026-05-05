// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <mpi.h>
#include "convert_handles.h"
#include "convert_constants.h"

void C_MPI_Get(void * origin_addr, int origin_count, int origin_datatype_f,
               int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
               int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Get(origin_addr, origin_count, origin_datatype,
                      target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                      win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Put(const void * origin_addr, int origin_count, int origin_datatype_f,
               int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
               int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Put(origin_addr, origin_count, origin_datatype,
                      target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                      win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Rget(void * origin_addr, int origin_count, int origin_datatype_f,
                int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                int win_f, int * request_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_Rget(origin_addr, origin_count, origin_datatype,
                       target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                       win, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Rput(const void * origin_addr, int origin_count, int origin_datatype_f,
                int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                int win_f, int * request_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    MPI_Request request = MPI_REQUEST_NULL;
    *ierror = MPI_Rput(origin_addr, origin_count, origin_datatype,
                       target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                       win, &request);
    *request_f = MPI_Request_c2f(request);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Accumulate(const void * origin_addr, int origin_count, int origin_datatype_f,
                      int target_rank, intptr_t target_disp, int target_count, int target_datatype_f,
                      int op_f, int win_f, int * ierror)
{
    MPI_Datatype origin_datatype = C_MPI_TYPE_F2C(origin_datatype_f);
    MPI_Datatype target_datatype = C_MPI_TYPE_F2C(target_datatype_f);
    MPI_Op op = C_MPI_OP_F2C(op_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Accumulate(origin_addr, origin_count, origin_datatype,
                             target_rank, (MPI_Aint)target_disp, target_count, target_datatype,
                             op, win);
    C_MPI_RC_FIX(*ierror);
}

void C_MPI_Fetch_and_op(const void * origin_addr, void * result_addr, int datatype_f,
                        int target_rank, intptr_t target_disp, int op_f, int win_f, int * ierror)
{
    MPI_Datatype datatype = C_MPI_TYPE_F2C(datatype_f);
    MPI_Op op = C_MPI_OP_F2C(op_f);
    MPI_Win win = C_MPI_WIN_F2C(win_f);
    *ierror = MPI_Fetch_and_op(origin_addr, result_addr, datatype,
                               target_rank, (MPI_Aint)target_disp, op, win);
    C_MPI_RC_FIX(*ierror);
}
