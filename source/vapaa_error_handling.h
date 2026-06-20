// SPDX-License-Identifier: MIT

#ifndef VAPAA_ERROR_HANDLING_H
#define VAPAA_ERROR_HANDLING_H

#include <mpi.h>

void VAPAA_MPI_note_comm_errhandler_set(void);
void VAPAA_MPI_note_file_errhandler_set(void);
void VAPAA_MPI_note_win_errhandler_set(void);
void VAPAA_MPI_note_session_errhandler_set(void);

void VAPAA_MPI_handle_synthetic_error_no_object(int *ierror);
void VAPAA_MPI_handle_synthetic_error_comm(MPI_Comm comm, int *ierror);
void VAPAA_MPI_handle_synthetic_error_file(MPI_File file, int *ierror);
void VAPAA_MPI_handle_synthetic_error_win(MPI_Win win, int *ierror);
#if MPI_VERSION >= 4
void VAPAA_MPI_handle_synthetic_error_session(MPI_Session session, int *ierror);
#else
void VAPAA_MPI_handle_synthetic_error_session_null(int *ierror);
#endif

void C_MPI_Fatal_if_missing_ierror(const int *ierror_f);

#endif
