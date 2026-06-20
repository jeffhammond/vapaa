// SPDX-License-Identifier: MIT

#include <stdlib.h>
#include <mpi.h>
#include "convert_constants.h"
#include "vapaa_error_handling.h"

static int vapaa_comm_errhandler_dirty = 0;
static int vapaa_file_errhandler_dirty = 0;
static int vapaa_win_errhandler_dirty = 0;
static int vapaa_session_errhandler_dirty = 0;

static int VAPAA_MPI_is_active(void)
{
    int initialized = 0;
    int finalized = 0;
    (void) MPI_Initialized(&initialized);
    (void) MPI_Finalized(&finalized);
    return initialized && !finalized;
}

static void VAPAA_MPI_abort_without_return(int error_c)
{
    if (VAPAA_MPI_is_active()) {
        (void) MPI_Abort(MPI_COMM_WORLD, error_c);
    }
    abort();
}

void VAPAA_MPI_note_comm_errhandler_set(void)
{
    vapaa_comm_errhandler_dirty = 1;
}

void VAPAA_MPI_note_file_errhandler_set(void)
{
    vapaa_file_errhandler_dirty = 1;
}

void VAPAA_MPI_note_win_errhandler_set(void)
{
    vapaa_win_errhandler_dirty = 1;
}

void VAPAA_MPI_note_session_errhandler_set(void)
{
    vapaa_session_errhandler_dirty = 1;
}

void VAPAA_MPI_handle_synthetic_error_no_object(int *ierror)
{
    if (*ierror == MPI_SUCCESS) {
        return;
    }
    if (!VAPAA_MPI_is_active()) {
        VAPAA_MPI_abort_without_return(*ierror);
    }
    (void) MPI_Comm_call_errhandler(MPI_COMM_SELF, *ierror);
}

void VAPAA_MPI_handle_synthetic_error_comm(MPI_Comm comm, int *ierror)
{
    if (*ierror == MPI_SUCCESS) {
        return;
    }
    if (!VAPAA_MPI_is_active()) {
        VAPAA_MPI_abort_without_return(*ierror);
    }

    (void) vapaa_comm_errhandler_dirty;
    (void) MPI_Comm_call_errhandler(comm, *ierror);
}

void VAPAA_MPI_handle_synthetic_error_file(MPI_File file, int *ierror)
{
    if (*ierror == MPI_SUCCESS) {
        return;
    }
    if (!VAPAA_MPI_is_active()) {
        VAPAA_MPI_abort_without_return(*ierror);
    }

    if (vapaa_file_errhandler_dirty) {
        (void) MPI_File_call_errhandler(file, *ierror);
    }
}

void VAPAA_MPI_handle_synthetic_error_win(MPI_Win win, int *ierror)
{
    if (*ierror == MPI_SUCCESS) {
        return;
    }
    if (!VAPAA_MPI_is_active()) {
        VAPAA_MPI_abort_without_return(*ierror);
    }

    (void) vapaa_win_errhandler_dirty;
    (void) MPI_Win_call_errhandler(win, *ierror);
}

#if MPI_VERSION >= 4
void VAPAA_MPI_handle_synthetic_error_session(MPI_Session session, int *ierror)
{
    if (*ierror == MPI_SUCCESS) {
        return;
    }
    if (!VAPAA_MPI_is_active()) {
        VAPAA_MPI_abort_without_return(*ierror);
    }

    (void) vapaa_session_errhandler_dirty;
    (void) MPI_Session_call_errhandler(session, *ierror);
}
#else
void VAPAA_MPI_handle_synthetic_error_session_null(int *ierror)
{
    VAPAA_MPI_handle_synthetic_error_no_object(ierror);
}
#endif

void C_MPI_Fatal_if_missing_ierror(const int *ierror_f)
{
    int error_c = C_MPI_ERROR_CODE_F2C(*ierror_f);
    if (error_c == MPI_SUCCESS) {
        return;
    }

    if (VAPAA_MPI_is_active()) {
        (void) MPI_Comm_call_errhandler(MPI_COMM_SELF, error_c);
    }
    VAPAA_MPI_abort_without_return(error_c);
}
