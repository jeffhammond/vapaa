# W-Collective Risk Backlog

Date: 2026-06-21

Scope: adversarial review of the `MPI_Ialltoallw`, `MPI_Ineighbor_alltoallw`, and disabled persistent W-collective wrapper paths after the grequest-based implementation.

## Findings

### Grequest state can be freed before worker completion

`VAPAA_Wcollective_free` destroys the mutex and frees the request state, while the detached worker may still be executing with pointers into that state. A user can reach this by calling `MPI_Request_free` on the generalized request before the worker completes.

Relevant code:

- `source/vapaa_wcollective_grequest.c`: `VAPAA_Wcollective_free`
- `source/vapaa_wcollective_grequest.c`: `VAPAA_Wcollective_worker`

Because cancelling/freeing a nonblocking collective request is erroneous, one acceptable fix may be to abort on request-free for this grequest, matching the cancel behavior. A more complete fix would add a reference/lifetime protocol between the worker and the MPI free callback.

### Communicator and datatype lifetimes are borrowed

The worker stores raw `MPI_Comm` and `MPI_Datatype` handles and may not enter the blocking collective until after the wrapper returns. Native nonblocking collectives initiate immediately; this pthread implementation does not. A caller that frees a communicator or derived datatype after initiation but before completion can leave the worker using invalid handles.

Relevant code:

- `source/vapaa_wcollective_grequest.c`: state fields `comm`, `sendtypes`, `recvtypes`
- `source/vapaa_wcollective_grequest.c`: `VAPAA_Wcollective_perform`
- `source/mpi_direct_collective.c`: `VAPAA_MPI_Ialltoallw`
- `source/mpi_direct_collective.c`: `VAPAA_MPI_Ineighbor_alltoallw`

Possible mitigations include duplicating the communicator and retaining/freeing datatype handles in the grequest state.

### f77 `MPI_Ialltoallw` mishandles `MPI_IN_PLACE`

The f77 nonblocking alltoallw path converts `sendtypes_f` before checking `MPI_IN_PLACE`, then passes the user's ignored send arrays through to the grequest helper. The f08 and PGIF paths allocate owned zero-count/null-type send arrays for in-place use, so the f77 path is inconsistent and may read past short placeholder arrays.

Relevant code:

- `source/mpi_f77.c`: `mpi_ialltoallw_`
- Compare with `source/mpi_direct_collective.c`: `VAPAA_MPI_Ialltoallw`
- Compare with `source/mpi_direct_collective_pgif.c`: `vapaa_mpi_ialltoallw_`

### Startup errors are not handled uniformly

Some setup failures are ignored or returned without routing through the communicator error handler:

- `MPI_Comm_size` is ignored in f08/PGIF `MPI_Ialltoallw` wrappers.
- Neighbor topology discovery swallows errors and can produce zero-degree arrays.
- Allocation and mutex failures in the grequest helper can return `MPI_ERR_OTHER` without invoking the communicator error handler.

Relevant code:

- `source/mpi_direct_collective.c`: `VAPAA_MPI_Ialltoallw`
- `source/mpi_direct_collective.c`: `VAPAA_COLL_NEIGHBOR_DEGREES`
- `source/vapaa_wcollective_grequest.c`: `VAPAA_Grequest_alltoallw`
- `source/vapaa_wcollective_grequest.c`: `VAPAA_Wcollective_start`

### Test coverage misses adversarial lifetimes

Current tests cover successful wait and thread-level rejection, but not the cases most likely to expose production failures:

- `MPI_Request_free` before completion.
- Communicator free after initiation and before wait.
- Derived datatype free after initiation and before wait.
- f77 `MPI_IN_PLACE` with short ignored send arrays.
- Invalid topology with `MPI_ERRORS_RETURN`.
- Delayed `MPI_Ineighbor_alltoallw` completion.

Relevant tests:

- `tests/test_wcollective_grequest_thread.F90`
- `tests/test_wcollective_thread_level_error.F90`
- `tests/test_mpifh_comm_io_rma.f`

### Non-CMake pthread linkage is fragile

CMake links the library with `Threads::Threads`, but the plain `source/Makefile` only archives `vapaa_wcollective_grequest.o`. Static-library consumers using the makefile path must still link with pthread support themselves.

Relevant code:

- `CMakeLists.txt`: `target_link_libraries(${vapa_lib} PUBLIC $<LINK_ONLY:Threads::Threads>)`
- `source/Makefile`: `libmpi_f08.a`

## Current Persistent W-Init Status

`MPI_Alltoallw_init` and `MPI_Neighbor_alltoallw_init` now return `MPI_ERR_UNSUPPORTED_OPERATION` with `MPI_REQUEST_NULL` instead of creating unsafe persistent operations. The corresponding coverage calls were removed. That avoids the known free-before-complete issue in those persistent wrappers.

Relevant commit:

- `957ee82 Disable persistent alltoallw wrappers`
