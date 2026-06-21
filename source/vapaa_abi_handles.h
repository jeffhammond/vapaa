#ifndef VAPAA_ABI_HANDLES_H
#define VAPAA_ABI_HANDLES_H

#include <mpi.h>

MPI_Comm VAPAA_MPI_Comm_fromint(int comm);
int VAPAA_MPI_Comm_toint(MPI_Comm comm);
MPI_Errhandler VAPAA_MPI_Errhandler_fromint(int errhandler);
int VAPAA_MPI_Errhandler_toint(MPI_Errhandler errhandler);
MPI_File VAPAA_MPI_File_fromint(int file);
int VAPAA_MPI_File_toint(MPI_File file);
MPI_Group VAPAA_MPI_Group_fromint(int group);
int VAPAA_MPI_Group_toint(MPI_Group group);
MPI_Info VAPAA_MPI_Info_fromint(int info);
int VAPAA_MPI_Info_toint(MPI_Info info);
MPI_Message VAPAA_MPI_Message_fromint(int message);
int VAPAA_MPI_Message_toint(MPI_Message message);
MPI_Op VAPAA_MPI_Op_fromint(int op);
int VAPAA_MPI_Op_toint(MPI_Op op);
MPI_Request VAPAA_MPI_Request_fromint(int request);
int VAPAA_MPI_Request_toint(MPI_Request request);
#if MPI_VERSION >= 4
MPI_Session VAPAA_MPI_Session_fromint(int session);
int VAPAA_MPI_Session_toint(MPI_Session session);
#endif
MPI_Datatype VAPAA_MPI_Type_fromint(int datatype);
int VAPAA_MPI_Type_toint(MPI_Datatype datatype);
MPI_Win VAPAA_MPI_Win_fromint(int win);
int VAPAA_MPI_Win_toint(MPI_Win win);

#endif
