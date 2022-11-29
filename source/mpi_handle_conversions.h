#include <mpi.h>

// TODO: move all the constants into a header file and use case-switch.

#define MAYBE_UNUSED __attribute__((unused))

MAYBE_UNUSED
static MPI_Comm C_MPI_COMM_F2C(int comm_f)
{
    if (comm_f == -1000000) {
        return MPI_COMM_WORLD;
    } else if (comm_f == -1) {
        return MPI_COMM_SELF;
    } else if (comm_f == -911) {
        return MPI_COMM_NULL;
    } else {
        return MPI_Comm_f2c(comm_f);
    } 
}

// the numbers in this library are compile-time constants
// and can be used in a case-switch.  the MPI constants are
// guarenteed to be compile-time constants and need to use
// if-else logic. (see below)

#define DT_CASE(type,num) \
    case num: return type; break;

MAYBE_UNUSED
static MPI_Datatype C_MPI_TYPE_F2C(int type_f)
{
    switch (type_f) {
        case -911: return MPI_DATATYPE_NULL; break;
        DT_CASE(MPI_CHARACTER                   ,-1001)
        DT_CASE(MPI_LOGICAL                     ,-1002)
        DT_CASE(MPI_INTEGER                     ,-1003)
        DT_CASE(MPI_REAL                        ,-1004)
        DT_CASE(MPI_DOUBLE_PRECISION            ,-1005)
        DT_CASE(MPI_COMPLEX                     ,-1006)
        DT_CASE(MPI_DOUBLE_COMPLEX              ,-1007)
        DT_CASE(MPI_INTEGER1                    ,-1008)
        DT_CASE(MPI_INTEGER2                    ,-1009)
        DT_CASE(MPI_INTEGER4                    ,-1010)
        DT_CASE(MPI_INTEGER8                    ,-1011)
#ifdef HAVE_MPI_INTEGER16
        DT_CASE(MPI_INTEGER16                   ,-1012)
#else
        DT_CASE(MPI_DATATYPE_NULL               ,-1012)
#endif
#ifdef HAVE_MPI_REAL2
        DT_CASE(MPI_REAL2                       ,-1013)
#else
        DT_CASE(MPI_DATATYPE_NULL               ,-1013)
#endif
        DT_CASE(MPI_REAL4                       ,-1014)
        DT_CASE(MPI_REAL8                       ,-1015)
#ifdef HAVE_MPI_REAL16
        DT_CASE(MPI_REAL16                      ,-1016)
#else
        DT_CASE(MPI_DATATYPE_NULL               ,-1016)
#endif
#ifdef HAVE_MPI_COMPLEX4
        DT_CASE(MPI_COMPLEX4                    ,-1017)
#else
        DT_CASE(MPI_DATATYPE_NULL               ,-1017)
#endif
        DT_CASE(MPI_COMPLEX8                    ,-1018)
        DT_CASE(MPI_COMPLEX16                   ,-1019)
#ifdef HAVE_MPI_COMPLEX32
        DT_CASE(MPI_COMPLEX32                   ,-1020)
#else
        DT_CASE(MPI_DATATYPE_NULL               ,-1020)
#endif
        DT_CASE(MPI_AINT                        ,-2008)
        DT_CASE(MPI_COUNT                       ,-2009)
        DT_CASE(MPI_OFFSET                      ,-3010)
        DT_CASE(MPI_BYTE                        ,-3011)
        DT_CASE(MPI_CHAR                        ,-3012)
        DT_CASE(MPI_UNSIGNED_CHAR               ,-3013)
        DT_CASE(MPI_SIGNED_CHAR                 ,-3014)
        DT_CASE(MPI_WCHAR                       ,-3015)
        DT_CASE(MPI_SHORT                       ,-3016)
        DT_CASE(MPI_UNSIGNED_SHORT              ,-3017)
        DT_CASE(MPI_INT                         ,-3018)
        DT_CASE(MPI_LONG                        ,-3019)
        DT_CASE(MPI_UNSIGNED                    ,-3020)
        DT_CASE(MPI_UNSIGNED_LONG               ,-3021)
        DT_CASE(MPI_LONG_LONG_INT               ,-3022)
        DT_CASE(MPI_UNSIGNED_LONG_LONG          ,-3023)
        DT_CASE(MPI_FLOAT                       ,-3024)
        DT_CASE(MPI_DOUBLE                      ,-3025)
        DT_CASE(MPI_LONG_DOUBLE                 ,-3026)
        DT_CASE(MPI_C_BOOL                      ,-3027)
        DT_CASE(MPI_INT8_T                      ,-3028)
        DT_CASE(MPI_INT16_T                     ,-3029)
        DT_CASE(MPI_INT32_T                     ,-3030)
        DT_CASE(MPI_INT64_T                     ,-3031)
        DT_CASE(MPI_UINT8_T                     ,-3032)
        DT_CASE(MPI_UINT16_T                    ,-3033)
        DT_CASE(MPI_UINT32_T                    ,-3034)
        DT_CASE(MPI_UINT64_T                    ,-3035)
        DT_CASE(MPI_C_COMPLEX                   ,-3036)
        DT_CASE(MPI_C_FLOAT_COMPLEX             ,-3037)
        DT_CASE(MPI_C_DOUBLE_COMPLEX            ,-3038)
        DT_CASE(MPI_C_LONG_DOUBLE_COMPLEX       ,-3039)
        default: return MPI_Type_f2c(type_f); break;
    }
}

#undef DT_CASE

MAYBE_UNUSED
static MPI_File C_MPI_FILE_F2C(int file_f)
{
    if (file_f == -911) {
        return MPI_FILE_NULL;
    } else {
        return MPI_File_f2c(file_f);
    } 
}

MAYBE_UNUSED
static MPI_Group C_MPI_GROUP_F2C(int group_f)
{
    if (group_f == -911) {
        return MPI_GROUP_NULL;
    } else {
        return MPI_Group_f2c(group_f);
    } 
}

MAYBE_UNUSED
static MPI_Info C_MPI_INFO_F2C(int info_f)
{
    if (info_f == -911) {
        return MPI_INFO_NULL;
    } else {
        return MPI_Info_f2c(info_f);
    } 
}

MAYBE_UNUSED
static MPI_Message C_MPI_MESSAGE_F2C(int message_f)
{
    if (message_f == -911) {
        return MPI_MESSAGE_NULL;
    } else {
        return MPI_Message_f2c(message_f);
    } 
}

#define OP_CASE(op,num) \
    case num: return op; break;

MAYBE_UNUSED
static MPI_Op C_MPI_OP_F2C(int op_f)
{
    switch (op_f) {
        case -911: return MPI_OP_NULL; break;
        OP_CASE(MPI_MAX    ,-10001)
        OP_CASE(MPI_MIN    ,-10002)
        OP_CASE(MPI_SUM    ,-10003)
        OP_CASE(MPI_PROD   ,-10004)
        OP_CASE(MPI_MAXLOC ,-10005)
        OP_CASE(MPI_MINLOC ,-10006)
        OP_CASE(MPI_BAND   ,-10007)
        OP_CASE(MPI_BOR    ,-10008)
        OP_CASE(MPI_BXOR   ,-10009)
        OP_CASE(MPI_LAND   ,-10010)
        OP_CASE(MPI_LOR    ,-10011)
        OP_CASE(MPI_LXOR   ,-10012)
        OP_CASE(MPI_REPLACE,-10013)
        OP_CASE(MPI_NO_OP  ,-10014)
        default: return MPI_Op_f2c(op_f); break;
    } 
}

#undef OP_CASE

MAYBE_UNUSED
static MPI_Request C_MPI_REQUEST_F2C(int request_f)
{
    if (request_f == -911) {
        return MPI_REQUEST_NULL;
    } else {
        return MPI_Request_f2c(request_f);
    } 
}

/*******************************************************/

/* TODO:
 * I do not know if C2F will ever return a built-in.
 * If not, we can eliminate a lot of branches...
 */

#define DT_ELIF(type,num) \
    else if (type_c == (type)) { \
        return num; \
    }

MAYBE_UNUSED
static int C_MPI_TYPE_C2F(MPI_Datatype type_c)
{
    if (type_c == MPI_DATATYPE_NULL) {
        return -911;
    }
    DT_ELIF(MPI_CHARACTER                   ,-1001)
    DT_ELIF(MPI_LOGICAL                     ,-1002)
    DT_ELIF(MPI_INTEGER                     ,-1003)
    DT_ELIF(MPI_REAL                        ,-1004)
    DT_ELIF(MPI_DOUBLE_PRECISION            ,-1005)
    DT_ELIF(MPI_COMPLEX                     ,-1006)
    DT_ELIF(MPI_DOUBLE_COMPLEX              ,-1007)
    DT_ELIF(MPI_INTEGER1                    ,-1008)
    DT_ELIF(MPI_INTEGER2                    ,-1009)
    DT_ELIF(MPI_INTEGER4                    ,-1010)
    DT_ELIF(MPI_INTEGER8                    ,-1011)
#ifdef HAVE_MPI_INTEGER16
    DT_ELIF(MPI_INTEGER16                   ,-1012)
#else
    DT_ELIF(MPI_DATATYPE_NULL               ,-1012)
#endif
#ifdef HAVE_MPI_REAL2
    DT_ELIF(MPI_REAL2                       ,-1013)
#else
    DT_ELIF(MPI_DATATYPE_NULL               ,-1013)
#endif
    DT_ELIF(MPI_REAL4                       ,-1014)
    DT_ELIF(MPI_REAL8                       ,-1015)
#ifdef HAVE_MPI_REAL16
    DT_ELIF(MPI_REAL16                      ,-1016)
#else
    DT_ELIF(MPI_DATATYPE_NULL               ,-1016)
#endif
#ifdef HAVE_MPI_COMPLEX4
    DT_ELIF(MPI_COMPLEX4                    ,-1017)
#else
    DT_ELIF(MPI_DATATYPE_NULL               ,-1017)
#endif
    DT_ELIF(MPI_COMPLEX8                    ,-1018)
    DT_ELIF(MPI_COMPLEX16                   ,-1019)
#ifdef HAVE_MPI_COMPLEX32
    DT_ELIF(MPI_COMPLEX32                   ,-1020)
#else
    DT_ELIF(MPI_DATATYPE_NULL               ,-1020)
#endif
    DT_ELIF(MPI_AINT                        ,-2008)
    DT_ELIF(MPI_COUNT                       ,-2009)
    DT_ELIF(MPI_OFFSET                      ,-3010)
    DT_ELIF(MPI_BYTE                        ,-3011)
    DT_ELIF(MPI_CHAR                        ,-3012)
    DT_ELIF(MPI_UNSIGNED_CHAR               ,-3013)
    DT_ELIF(MPI_SIGNED_CHAR                 ,-3014)
    DT_ELIF(MPI_WCHAR                       ,-3015)
    DT_ELIF(MPI_SHORT                       ,-3016)
    DT_ELIF(MPI_UNSIGNED_SHORT              ,-3017)
    DT_ELIF(MPI_INT                         ,-3018)
    DT_ELIF(MPI_LONG                        ,-3019)
    DT_ELIF(MPI_UNSIGNED                    ,-3020)
    DT_ELIF(MPI_UNSIGNED_LONG               ,-3021)
    DT_ELIF(MPI_LONG_LONG_INT               ,-3022)
    DT_ELIF(MPI_UNSIGNED_LONG_LONG          ,-3023)
    DT_ELIF(MPI_FLOAT                       ,-3024)
    DT_ELIF(MPI_DOUBLE                      ,-3025)
    DT_ELIF(MPI_LONG_DOUBLE                 ,-3026)
    DT_ELIF(MPI_C_BOOL                      ,-3027)
    DT_ELIF(MPI_INT8_T                      ,-3028)
    DT_ELIF(MPI_INT16_T                     ,-3029)
    DT_ELIF(MPI_INT32_T                     ,-3030)
    DT_ELIF(MPI_INT64_T                     ,-3031)
    DT_ELIF(MPI_UINT8_T                     ,-3032)
    DT_ELIF(MPI_UINT16_T                    ,-3033)
    DT_ELIF(MPI_UINT32_T                    ,-3034)
    DT_ELIF(MPI_UINT64_T                    ,-3035)
    DT_ELIF(MPI_C_COMPLEX                   ,-3036)
    DT_ELIF(MPI_C_FLOAT_COMPLEX             ,-3037)
    DT_ELIF(MPI_C_DOUBLE_COMPLEX            ,-3038)
    DT_ELIF(MPI_C_LONG_DOUBLE_COMPLEX       ,-3039)
    else {
        return MPI_Type_c2f(type_c);
    } 
}

#undef DT_ELIF

