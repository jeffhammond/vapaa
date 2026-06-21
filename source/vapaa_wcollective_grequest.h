// SPDX-License-Identifier: MIT

#ifndef VAPAA_WCOLLECTIVE_GREQUEST_H
#define VAPAA_WCOLLECTIVE_GREQUEST_H

#include <mpi.h>

int VAPAA_Grequest_alltoallw(const void *sendbuf, const int sendcounts[],
                             const int sdispls[], MPI_Datatype sendtypes[],
                             void *recvbuf, const int recvcounts[],
                             const int rdispls[], MPI_Datatype recvtypes[],
                             MPI_Comm comm, int *owned_sendcounts,
                             int *owned_sdispls, MPI_Datatype *owned_sendtypes,
                             MPI_Datatype *owned_recvtypes,
                             MPI_Request *request);

int VAPAA_Grequest_neighbor_alltoallw(const void *sendbuf,
                                      const int sendcounts[],
                                      MPI_Aint sdispls[],
                                      MPI_Datatype sendtypes[],
                                      void *recvbuf,
                                      const int recvcounts[],
                                      MPI_Aint rdispls[],
                                      MPI_Datatype recvtypes[],
                                      MPI_Comm comm,
                                      MPI_Aint *owned_sdispls,
                                      MPI_Datatype *owned_sendtypes,
                                      MPI_Aint *owned_rdispls,
                                      MPI_Datatype *owned_recvtypes,
                                      MPI_Request *request);

#endif
