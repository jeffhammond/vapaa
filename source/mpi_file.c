#include <mpi.h>
#include "ISO_Fortran_binding.h"

// NOT STANDARD STUFF

void C_MPI_FILE_NULL(int * file)
{
    *file = MPI_File_c2f(MPI_FILE_NULL);
}

// STANDARD STUFF

void C_MPI_File_open(int * comm_f, CFI_cdesc_t * filename_d, int * amode, int * info_f, int * file_f, int * ierror)
{
    MPI_File file = MPI_FILE_NULL;
    MPI_Comm comm = MPI_Comm_f2c(*comm_f);
    MPI_Info info = MPI_Info_f2c(*info_f);
    char * filename = filename_d -> base_addr;
    *ierror = MPI_File_open(comm, filename, *amode, info, &file);
    *file_f = MPI_File_c2f(file);
}

void C_MPI_File_close(int * file_f, int * ierror)
{
    MPI_File file = MPI_File_f2c(*file_f);
    *ierror = MPI_File_close(&file);
    *file_f = MPI_File_c2f(file);
}
