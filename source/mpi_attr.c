#include <string.h>
#include <mpi.h>
#include "ISO_Fortran_binding.h"
#include "convert_handles.h"
#include "convert_constants.h"

void C_MPI_Type_set_name(int * type_f, char ** pname, int * ierror)
{
    MPI_Datatype type = C_MPI_TYPE_F2C(*type_f);
    char * name = *pname;
    *ierror = MPI_Type_set_name(type, name);
    C_MPI_RC_FIX(*ierror);
}

#ifdef HAVE_CFI
void CFI_MPI_Type_set_name(int * type_f, CFI_cdesc_t * name_d, int * ierror)
{
    MPI_Datatype type = C_MPI_TYPE_F2C(*type_f);
    char * name = name_d -> base_addr;
    *ierror = MPI_Type_set_name(type, name);
    C_MPI_RC_FIX(*ierror);
}
#endif
