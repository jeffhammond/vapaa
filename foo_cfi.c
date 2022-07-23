#include <stdio.h>
#include <stdlib.h>
#include "ISO_Fortran_binding.h"

void foo(CFI_cdesc_t * desc)
{
    printf("base_addr = %p\n", desc->base_addr);
    printf("elem_len  = %zu\n", desc->elem_len);


}
