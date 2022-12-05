#include "ISO_Fortran_binding.h"

void * f08_MPI_BOTTOM_address = {0};          // MPI_BOTTOM
void * f08_MPI_STATUS_IGNORE_address = {0};   // MPI_STATUS_IGNORE
void * f08_MPI_STATUSES_IGNORE_address = {0}; // MPI_STATUSES_IGNORE
void * f08_MPI_ERRCODES_IGNORE_address = {0}; // MPI_ERRCODES_IGNORE
void * f08_MPI_IN_PLACE_address = {0};        // MPI_IN_PLACE
void * f08_MPI_ARGV_NULL_address = {0};       // MPI_ARGV_NULL
void * f08_MPI_ARGVS_NULL_address = {0};      // MPI_ARGVS_NULL
void * f08_MPI_UNWEIGHTED_address = {0};      // MPI_UNWEIGHTED
void * f08_MPI_WEIGHTS_EMPTY_address = {0};   // MPI_WEIGHTS_EMPTY

#ifdef HAVE_CFI
void C_MPI_BOTTOM(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_BOTTOM_address = addr;
}
#else
void C_MPI_BOTTOM(void * class)
{
    f08_MPI_BOTTOM_address = class;
}
#endif

#ifdef HAVE_CFI
void C_MPI_STATUS_IGNORE(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_STATUS_IGNORE_address = addr;
}
#else
void C_MPI_STATUS_IGNORE(void * class)
{
    f08_MPI_STATUS_IGNORE_address = class;
}
#endif

#ifdef HAVE_CFI
void C_MPI_STATUSES_IGNORE(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_STATUSES_IGNORE_address = addr;
}
#else
void C_MPI_STATUSES_IGNORE(void * class)
{
    f08_MPI_STATUSES_IGNORE_address = class;
}
#endif

#ifdef HAVE_CFI
void C_MPI_ERRCODES_IGNORE(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_ERRCODES_IGNORE_address = addr;
}
#else
void C_MPI_ERRCODES_IGNORE(void * class)
{
    f08_MPI_ERRCODES_IGNORE_address = class;
}
#endif

#ifdef HAVE_CFI
void C_MPI_IN_PLACE(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_IN_PLACE_address = addr;
}
#else
void C_MPI_IN_PLACE(void * class)
{
    f08_MPI_IN_PLACE_address = class;
}
#endif

#ifdef HAVE_CFI
void C_MPI_ARGV_NULL(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_ARGV_NULL_address = addr;
}
#else
void C_MPI_ARGV_NULL(void * class)
{
    f08_MPI_ARGV_NULL_address = class;
}
#endif

#ifdef HAVE_CFI
void C_MPI_ARGVS_NULL(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_ARGVS_NULL_address = addr;
}
#else
void C_MPI_ARGVS_NULL(void * class)
{
    f08_MPI_ARGVS_NULL_address = class;
}
#endif

#ifdef HAVE_CFI
void C_MPI_UNWEIGHTED(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_UNWEIGHTED_address = addr;
}
#else
void C_MPI_UNWEIGHTED(void * class)
{
    f08_MPI_UNWEIGHTED_address = class;
}
#endif

#ifdef HAVE_CFI
void C_MPI_WEIGHTS_EMPTY(CFI_cdesc_t * desc)
{
    void * addr = desc->base_addr;
    f08_MPI_WEIGHTS_EMPTY_address = addr;
}
#else
void C_MPI_WEIGHTS_EMPTY(void * class)
{
    f08_MPI_WEIGHTS_EMPTY_address = class;
}
#endif
