#include <mpi.h>
#include "ISO_Fortran_binding.h"

void C_MPI_Info_create(int * info_f, int * ierror)
{
    MPI_Info info = MPI_INFO_NULL;
    *ierror = MPI_Info_create(&info);
    *info_f = MPI_Info_c2f(info);
}

void CFI_MPI_Info_delete(int * info_f, CFI_cdesc_t * key_d, int * ierror)
{
    MPI_Info info = MPI_Info_f2c(*info_f);
    char * key = key_d -> base_addr;
    *ierror = MPI_Info_delete(info, key);
}

void C_MPI_Info_dup(int * info_f, int * newinfo_f, int * ierror)
{
    MPI_Info newinfo = MPI_INFO_NULL;
    MPI_Info info = MPI_Info_f2c(*info_f);
    *ierror = MPI_Info_dup(info,&newinfo);
    *newinfo_f = MPI_Info_c2f(newinfo);
}

void C_MPI_Info_free(int * info_f, int * ierror)
{
    MPI_Info info = MPI_Info_f2c(*info_f);
    *ierror = MPI_Info_free(&info);
    *info_f = MPI_Info_c2f(info);
}

void C_MPI_Info_get_nkeys(int * info_f, int * nkeys_f, int * ierror)
{
    MPI_Info info = MPI_Info_f2c(*info_f);
    *ierror = MPI_Info_get_nkeys(info, nkeys_f);
}

void CFI_MPI_Info_get_nthkey(int * info_f, int * n, CFI_cdesc_t * key_d, int * ierror)
{
    MPI_Info info = MPI_Info_f2c(*info_f);
    char * key = key_d -> base_addr;
    *ierror = MPI_Info_get_nthkey(info, *n, key);
}

void CFI_MPI_Info_get_string(int * info_f, CFI_cdesc_t * key_d, int * buflen, CFI_cdesc_t * val_d, int * flag, int * ierror)
{
    MPI_Info info = MPI_Info_f2c(*info_f);
    char * key = key_d -> base_addr;
    char * val = val_d -> base_addr;
    *ierror = MPI_Info_get_string(info, key, buflen, val, flag);
}

void CFI_MPI_Info_set(int * info_f, CFI_cdesc_t * key_d, CFI_cdesc_t * val_d, int * ierror)
{
    MPI_Info info = MPI_Info_f2c(*info_f);
    char * key = key_d -> base_addr;
    char * val = val_d -> base_addr;
    *ierror = MPI_Info_set(info, key, val);
}
