! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_f90_constants
    use iso_c_binding, only: c_int, c_int64_t, c_intptr_t
    implicit none

    integer, parameter :: MPI_THREAD_SINGLE     = VAPAA_MPI_THREAD_SINGLE
    integer, parameter :: MPI_THREAD_FUNNELED   = VAPAA_MPI_THREAD_FUNNELED
    integer, parameter :: MPI_THREAD_SERIALIZED = VAPAA_MPI_THREAD_SERIALIZED
    integer, parameter :: MPI_THREAD_MULTIPLE   = VAPAA_MPI_THREAD_MULTIPLE

    integer, parameter :: MPI_IDENT     = VAPAA_MPI_IDENT
    integer, parameter :: MPI_CONGRUENT = VAPAA_MPI_CONGRUENT
    integer, parameter :: MPI_SIMILAR   = VAPAA_MPI_SIMILAR
    integer, parameter :: MPI_UNEQUAL   = VAPAA_MPI_UNEQUAL

    integer, parameter :: MPI_CART       = VAPAA_MPI_CART
    integer, parameter :: MPI_GRAPH      = VAPAA_MPI_GRAPH
    integer, parameter :: MPI_DIST_GRAPH = VAPAA_MPI_DIST_GRAPH

    integer, parameter :: MPI_COMM_NULL  = VAPAA_MPI_COMM_NULL
    integer, parameter :: MPI_COMM_WORLD = VAPAA_MPI_COMM_WORLD
    integer, parameter :: MPI_COMM_SELF  = VAPAA_MPI_COMM_SELF

    integer, parameter :: MPI_GROUP_NULL  = VAPAA_MPI_GROUP_NULL
    integer, parameter :: MPI_GROUP_EMPTY = VAPAA_MPI_GROUP_EMPTY
    integer, parameter :: MPI_WIN_NULL    = VAPAA_MPI_WIN_NULL
    integer, parameter :: MPI_FILE_NULL   = VAPAA_MPI_FILE_NULL
    integer, parameter :: MPI_SESSION_NULL = VAPAA_MPI_SESSION_NULL
    integer, parameter :: MPI_MESSAGE_NULL = VAPAA_MPI_MESSAGE_NULL
    integer, parameter :: MPI_MESSAGE_NO_PROC = VAPAA_MPI_MESSAGE_NO_PROC
    integer, parameter :: MPI_INFO_NULL = VAPAA_MPI_INFO_NULL
    integer, parameter :: MPI_INFO_ENV = VAPAA_MPI_INFO_ENV
    integer, parameter :: MPI_ERRHANDLER_NULL = VAPAA_MPI_ERRHANDLER_NULL
    integer, parameter :: MPI_ERRORS_ARE_FATAL = VAPAA_MPI_ERRORS_ARE_FATAL
    integer, parameter :: MPI_ERRORS_ABORT = VAPAA_MPI_ERRORS_ABORT
    integer, parameter :: MPI_ERRORS_RETURN = VAPAA_MPI_ERRORS_RETURN
    integer, parameter :: MPI_REQUEST_NULL = VAPAA_MPI_REQUEST_NULL
    integer, parameter :: MPI_DATATYPE_NULL = VAPAA_MPI_DATATYPE_NULL
    integer, parameter :: MPI_OP_NULL = VAPAA_MPI_OP_NULL

    integer, parameter :: MPI_ANY_SOURCE = VAPAA_MPI_ANY_SOURCE
    integer, parameter :: MPI_ANY_TAG = VAPAA_MPI_ANY_TAG
    integer, parameter :: MPI_PROC_NULL = VAPAA_MPI_PROC_NULL
    integer, parameter :: MPI_ROOT = VAPAA_MPI_ROOT
    integer, parameter :: MPI_UNDEFINED = VAPAA_MPI_UNDEFINED

    integer, parameter :: MPI_ORDER_C = VAPAA_MPI_ORDER_C
    integer, parameter :: MPI_ORDER_FORTRAN = VAPAA_MPI_ORDER_FORTRAN
    integer, parameter :: MPI_DISTRIBUTE_NONE = VAPAA_MPI_DISTRIBUTE_NONE
    integer, parameter :: MPI_DISTRIBUTE_BLOCK = VAPAA_MPI_DISTRIBUTE_BLOCK
    integer, parameter :: MPI_DISTRIBUTE_CYCLIC = VAPAA_MPI_DISTRIBUTE_CYCLIC
    integer, parameter :: MPI_DISTRIBUTE_DFLT_DARG = VAPAA_MPI_DISTRIBUTE_DFLT_DARG

    integer, parameter :: MPI_COMBINER_NAMED = VAPAA_MPI_COMBINER_NAMED
    integer, parameter :: MPI_COMBINER_DUP = VAPAA_MPI_COMBINER_DUP
    integer, parameter :: MPI_COMBINER_CONTIGUOUS = VAPAA_MPI_COMBINER_CONTIGUOUS
    integer, parameter :: MPI_COMBINER_VECTOR = VAPAA_MPI_COMBINER_VECTOR
    integer, parameter :: MPI_COMBINER_HVECTOR = VAPAA_MPI_COMBINER_HVECTOR
    integer, parameter :: MPI_COMBINER_INDEXED = VAPAA_MPI_COMBINER_INDEXED
    integer, parameter :: MPI_COMBINER_HINDEXED = VAPAA_MPI_COMBINER_HINDEXED
    integer, parameter :: MPI_COMBINER_INDEXED_BLOCK = VAPAA_MPI_COMBINER_INDEXED_BLOCK
    integer, parameter :: MPI_COMBINER_HINDEXED_BLOCK = VAPAA_MPI_COMBINER_HINDEXED_BLOCK
    integer, parameter :: MPI_COMBINER_STRUCT = VAPAA_MPI_COMBINER_STRUCT
    integer, parameter :: MPI_COMBINER_SUBARRAY = VAPAA_MPI_COMBINER_SUBARRAY
    integer, parameter :: MPI_COMBINER_DARRAY = VAPAA_MPI_COMBINER_DARRAY
    integer, parameter :: MPI_COMBINER_F90_REAL = VAPAA_MPI_COMBINER_F90_REAL
    integer, parameter :: MPI_COMBINER_F90_COMPLEX = VAPAA_MPI_COMBINER_F90_COMPLEX
    integer, parameter :: MPI_COMBINER_F90_INTEGER = VAPAA_MPI_COMBINER_F90_INTEGER
    integer, parameter :: MPI_COMBINER_RESIZED = VAPAA_MPI_COMBINER_RESIZED
    integer, parameter :: MPI_COMBINER_VALUE_INDEX = VAPAA_MPI_COMBINER_VALUE_INDEX

    integer, parameter :: MPI_TYPECLASS_INTEGER = VAPAA_MPI_TYPECLASS_INTEGER
    integer, parameter :: MPI_TYPECLASS_REAL = VAPAA_MPI_TYPECLASS_REAL
    integer, parameter :: MPI_TYPECLASS_COMPLEX = VAPAA_MPI_TYPECLASS_COMPLEX

    integer, parameter :: MPI_COMM_TYPE_SHARED = VAPAA_MPI_COMM_TYPE_SHARED
    integer, parameter :: MPI_COMM_TYPE_HW_UNGUIDED = VAPAA_MPI_COMM_TYPE_HW_UNGUIDED
    integer, parameter :: MPI_COMM_TYPE_HW_GUIDED = VAPAA_MPI_COMM_TYPE_HW_GUIDED
    integer, parameter :: MPI_COMM_TYPE_RESOURCE_GUIDED = VAPAA_MPI_COMM_TYPE_RESOURCE_GUIDED

    integer, parameter :: MPI_MAX_PROCESSOR_NAME = VAPAA_MPI_MAX_PROCESSOR_NAME
    integer, parameter :: MPI_MAX_LIBRARY_VERSION_STRING = VAPAA_MPI_MAX_LIBRARY_VERSION_STRING
    integer, parameter :: MPI_MAX_ERROR_STRING = VAPAA_MPI_MAX_ERROR_STRING
    integer, parameter :: MPI_MAX_DATAREP_STRING = VAPAA_MPI_MAX_DATAREP_STRING
    integer, parameter :: MPI_MAX_INFO_KEY = VAPAA_MPI_MAX_INFO_KEY
    integer, parameter :: MPI_MAX_INFO_VAL = VAPAA_MPI_MAX_INFO_VAL
    integer, parameter :: MPI_MAX_OBJECT_NAME = VAPAA_MPI_MAX_OBJECT_NAME
    integer, parameter :: MPI_MAX_PORT_NAME = VAPAA_MPI_MAX_PORT_NAME
    integer, parameter :: MPI_MAX_STRINGTAG_LEN = VAPAA_MPI_MAX_STRINGTAG_LEN
    integer, parameter :: MPI_MAX_PSET_NAME_LEN = VAPAA_MPI_MAX_PSET_NAME_LEN
    integer, parameter :: MPI_BSEND_OVERHEAD = VAPAA_MPI_BSEND_OVERHEAD
    integer, parameter :: MPI_KEYVAL_INVALID = VAPAA_MPI_KEYVAL_INVALID

    integer, parameter :: MPI_TAG_UB = VAPAA_MPI_TAG_UB
    integer, parameter :: MPI_IO = VAPAA_MPI_IO
    integer, parameter :: MPI_HOST = VAPAA_MPI_HOST
    integer, parameter :: MPI_WTIME_IS_GLOBAL = VAPAA_MPI_WTIME_IS_GLOBAL
    integer, parameter :: MPI_APPNUM = VAPAA_MPI_APPNUM
    integer, parameter :: MPI_LASTUSEDCODE = VAPAA_MPI_LASTUSEDCODE
    integer, parameter :: MPI_LASTUSECODE = VAPAA_MPI_LASTUSEDCODE
    integer, parameter :: MPI_UNIVERSE_SIZE = VAPAA_MPI_UNIVERSE_SIZE

    integer, parameter :: MPI_WIN_BASE = VAPAA_MPI_WIN_BASE
    integer, parameter :: MPI_WIN_DISP_UNIT = VAPAA_MPI_WIN_DISP_UNIT
    integer, parameter :: MPI_WIN_SIZE = VAPAA_MPI_WIN_SIZE
    integer, parameter :: MPI_WIN_CREATE_FLAVOR = VAPAA_MPI_WIN_CREATE_FLAVOR
    integer, parameter :: MPI_WIN_MODEL = VAPAA_MPI_WIN_MODEL

    integer, parameter :: MPI_VERSION = 5
    integer, parameter :: MPI_SUBVERSION = 0

    integer, parameter :: MPI_STATUS_SIZE = 8
    integer, parameter :: MPI_SOURCE = 1
    integer, parameter :: MPI_TAG = 2
    integer, parameter :: MPI_ERROR = 3

    integer, parameter :: MPI_ADDRESS_KIND = c_intptr_t
    integer, parameter :: MPI_COUNT_KIND = c_int64_t
    integer, parameter :: MPI_INTEGER_KIND = c_int
    integer, parameter :: MPI_OFFSET_KIND = c_int64_t

    integer(kind=MPI_OFFSET_KIND), parameter :: MPI_DISPLACEMENT_CURRENT = VAPAA_MPI_DISPLACEMENT_CURRENT

    logical, parameter :: MPI_SUBARRAYS_SUPPORTED = .false.
    logical, parameter :: MPI_ASYNC_PROTECTS_NONBLOCKING = .true.

    integer, parameter :: MPI_MAX = VAPAA_MPI_MAX
    integer, parameter :: MPI_MIN = VAPAA_MPI_MIN
    integer, parameter :: MPI_SUM = VAPAA_MPI_SUM
    integer, parameter :: MPI_PROD = VAPAA_MPI_PROD
    integer, parameter :: MPI_MAXLOC = VAPAA_MPI_MAXLOC
    integer, parameter :: MPI_MINLOC = VAPAA_MPI_MINLOC
    integer, parameter :: MPI_BAND = VAPAA_MPI_BAND
    integer, parameter :: MPI_BOR = VAPAA_MPI_BOR
    integer, parameter :: MPI_BXOR = VAPAA_MPI_BXOR
    integer, parameter :: MPI_LAND = VAPAA_MPI_LAND
    integer, parameter :: MPI_LOR = VAPAA_MPI_LOR
    integer, parameter :: MPI_LXOR = VAPAA_MPI_LXOR
    integer, parameter :: MPI_REPLACE = VAPAA_MPI_REPLACE
    integer, parameter :: MPI_NO_OP = VAPAA_MPI_NO_OP

    integer, parameter :: MPI_CHARACTER = VAPAA_MPI_CHARACTER
    integer, parameter :: MPI_LOGICAL = VAPAA_MPI_LOGICAL
    integer, parameter :: MPI_INTEGER = VAPAA_MPI_INTEGER
    integer, parameter :: MPI_REAL = VAPAA_MPI_REAL
    integer, parameter :: MPI_DOUBLE_PRECISION = VAPAA_MPI_DOUBLE_PRECISION
    integer, parameter :: MPI_COMPLEX = VAPAA_MPI_COMPLEX
    integer, parameter :: MPI_DOUBLE_COMPLEX = VAPAA_MPI_DOUBLE_COMPLEX
    integer, parameter :: MPI_INTEGER1 = VAPAA_MPI_INTEGER1
    integer, parameter :: MPI_INTEGER2 = VAPAA_MPI_INTEGER2
    integer, parameter :: MPI_INTEGER4 = VAPAA_MPI_INTEGER4
    integer, parameter :: MPI_INTEGER8 = VAPAA_MPI_INTEGER8
    integer, parameter :: MPI_INTEGER16 = VAPAA_MPI_INTEGER16
    integer, parameter :: MPI_REAL2 = VAPAA_MPI_REAL2
    integer, parameter :: MPI_REAL4 = VAPAA_MPI_REAL4
    integer, parameter :: MPI_REAL8 = VAPAA_MPI_REAL8
    integer, parameter :: MPI_REAL16 = VAPAA_MPI_REAL16
    integer, parameter :: MPI_COMPLEX4 = VAPAA_MPI_COMPLEX4
    integer, parameter :: MPI_COMPLEX8 = VAPAA_MPI_COMPLEX8
    integer, parameter :: MPI_COMPLEX16 = VAPAA_MPI_COMPLEX16
    integer, parameter :: MPI_COMPLEX32 = VAPAA_MPI_COMPLEX32

    integer, parameter :: MPI_AINT = VAPAA_MPI_AINT
    integer, parameter :: MPI_COUNT = VAPAA_MPI_COUNT
    integer, parameter :: MPI_OFFSET = VAPAA_MPI_OFFSET
    integer, parameter :: MPI_LB = VAPAA_MPI_LB
    integer, parameter :: MPI_UB = VAPAA_MPI_UB
    integer, parameter :: MPI_PACKED = VAPAA_MPI_PACKED
    integer, parameter :: MPI_BYTE = VAPAA_MPI_BYTE
    integer, parameter :: MPI_CHAR = VAPAA_MPI_CHAR
    integer, parameter :: MPI_UNSIGNED_CHAR = VAPAA_MPI_UNSIGNED_CHAR
    integer, parameter :: MPI_SIGNED_CHAR = VAPAA_MPI_SIGNED_CHAR
    integer, parameter :: MPI_WCHAR = VAPAA_MPI_WCHAR
    integer, parameter :: MPI_SHORT = VAPAA_MPI_SHORT
    integer, parameter :: MPI_UNSIGNED_SHORT = VAPAA_MPI_UNSIGNED_SHORT
    integer, parameter :: MPI_INT = VAPAA_MPI_INT
    integer, parameter :: MPI_LONG = VAPAA_MPI_LONG
    integer, parameter :: MPI_LONG_LONG = VAPAA_MPI_LONG_LONG
    integer, parameter :: MPI_UNSIGNED = VAPAA_MPI_UNSIGNED
    integer, parameter :: MPI_UNSIGNED_LONG = VAPAA_MPI_UNSIGNED_LONG
    integer, parameter :: MPI_LONG_LONG_INT = VAPAA_MPI_LONG_LONG_INT
    integer, parameter :: MPI_UNSIGNED_LONG_LONG = VAPAA_MPI_UNSIGNED_LONG_LONG
    integer, parameter :: MPI_FLOAT = VAPAA_MPI_FLOAT
    integer, parameter :: MPI_DOUBLE = VAPAA_MPI_DOUBLE
    integer, parameter :: MPI_LONG_DOUBLE = VAPAA_MPI_LONG_DOUBLE
    integer, parameter :: MPI_C_BOOL = VAPAA_MPI_C_BOOL
    integer, parameter :: MPI_INT8_T = VAPAA_MPI_INT8_T
    integer, parameter :: MPI_INT16_T = VAPAA_MPI_INT16_T
    integer, parameter :: MPI_INT32_T = VAPAA_MPI_INT32_T
    integer, parameter :: MPI_INT64_T = VAPAA_MPI_INT64_T
    integer, parameter :: MPI_UINT8_T = VAPAA_MPI_UINT8_T
    integer, parameter :: MPI_UINT16_T = VAPAA_MPI_UINT16_T
    integer, parameter :: MPI_UINT32_T = VAPAA_MPI_UINT32_T
    integer, parameter :: MPI_UINT64_T = VAPAA_MPI_UINT64_T
    integer, parameter :: MPI_C_COMPLEX = VAPAA_MPI_C_COMPLEX
    integer, parameter :: MPI_C_FLOAT_COMPLEX = VAPAA_MPI_C_FLOAT_COMPLEX
    integer, parameter :: MPI_C_DOUBLE_COMPLEX = VAPAA_MPI_C_DOUBLE_COMPLEX
    integer, parameter :: MPI_C_LONG_DOUBLE_COMPLEX = VAPAA_MPI_C_LONG_DOUBLE_COMPLEX
    integer, parameter :: MPI_FLOAT_INT = VAPAA_MPI_FLOAT_INT
    integer, parameter :: MPI_DOUBLE_INT = VAPAA_MPI_DOUBLE_INT
    integer, parameter :: MPI_LONG_INT = VAPAA_MPI_LONG_INT
    integer, parameter :: MPI_2INT = VAPAA_MPI_2INT
    integer, parameter :: MPI_SHORT_INT = VAPAA_MPI_SHORT_INT
    integer, parameter :: MPI_LONG_DOUBLE_INT = VAPAA_MPI_LONG_DOUBLE_INT
    integer, parameter :: MPI_2REAL = VAPAA_MPI_2REAL
    integer, parameter :: MPI_2DOUBLE_PRECISION = VAPAA_MPI_2DOUBLE_PRECISION
    integer, parameter :: MPI_2INTEGER = VAPAA_MPI_2INTEGER

    integer, parameter :: MPI_SUCCESS = VAPAA_MPI_SUCCESS
    integer, parameter :: MPI_ERR_BUFFER = VAPAA_MPI_ERR_BUFFER
    integer, parameter :: MPI_ERR_COUNT = VAPAA_MPI_ERR_COUNT
    integer, parameter :: MPI_ERR_TYPE = VAPAA_MPI_ERR_TYPE
    integer, parameter :: MPI_ERR_TAG = VAPAA_MPI_ERR_TAG
    integer, parameter :: MPI_ERR_COMM = VAPAA_MPI_ERR_COMM
    integer, parameter :: MPI_ERR_RANK = VAPAA_MPI_ERR_RANK
    integer, parameter :: MPI_ERR_REQUEST = VAPAA_MPI_ERR_REQUEST
    integer, parameter :: MPI_ERR_ROOT = VAPAA_MPI_ERR_ROOT
    integer, parameter :: MPI_ERR_GROUP = VAPAA_MPI_ERR_GROUP
    integer, parameter :: MPI_ERR_OP = VAPAA_MPI_ERR_OP
    integer, parameter :: MPI_ERR_TOPOLOGY = VAPAA_MPI_ERR_TOPOLOGY
    integer, parameter :: MPI_ERR_DIMS = VAPAA_MPI_ERR_DIMS
    integer, parameter :: MPI_ERR_ARG = VAPAA_MPI_ERR_ARG
    integer, parameter :: MPI_ERR_UNKNOWN = VAPAA_MPI_ERR_UNKNOWN
    integer, parameter :: MPI_ERR_TRUNCATE = VAPAA_MPI_ERR_TRUNCATE
    integer, parameter :: MPI_ERR_OTHER = VAPAA_MPI_ERR_OTHER
    integer, parameter :: MPI_ERR_INTERN = VAPAA_MPI_ERR_INTERN
    integer, parameter :: MPI_ERR_PENDING = VAPAA_MPI_ERR_PENDING
    integer, parameter :: MPI_ERR_IN_STATUS = VAPAA_MPI_ERR_IN_STATUS
    integer, parameter :: MPI_ERR_ACCESS = VAPAA_MPI_ERR_ACCESS
    integer, parameter :: MPI_ERR_AMODE = VAPAA_MPI_ERR_AMODE
    integer, parameter :: MPI_ERR_ASSERT = VAPAA_MPI_ERR_ASSERT
    integer, parameter :: MPI_ERR_BAD_FILE = VAPAA_MPI_ERR_BAD_FILE
    integer, parameter :: MPI_ERR_BASE = VAPAA_MPI_ERR_BASE
    integer, parameter :: MPI_ERR_CONVERSION = VAPAA_MPI_ERR_CONVERSION
    integer, parameter :: MPI_ERR_DISP = VAPAA_MPI_ERR_DISP
    integer, parameter :: MPI_ERR_DUP_DATAREP = VAPAA_MPI_ERR_DUP_DATAREP
    integer, parameter :: MPI_ERR_FILE_EXISTS = VAPAA_MPI_ERR_FILE_EXISTS
    integer, parameter :: MPI_ERR_FILE_IN_USE = VAPAA_MPI_ERR_FILE_IN_USE
    integer, parameter :: MPI_ERR_FILE = VAPAA_MPI_ERR_FILE
    integer, parameter :: MPI_ERR_INFO_KEY = VAPAA_MPI_ERR_INFO_KEY
    integer, parameter :: MPI_ERR_INFO_NOKEY = VAPAA_MPI_ERR_INFO_NOKEY
    integer, parameter :: MPI_ERR_INFO_VALUE = VAPAA_MPI_ERR_INFO_VALUE
    integer, parameter :: MPI_ERR_INFO = VAPAA_MPI_ERR_INFO
    integer, parameter :: MPI_ERR_IO = VAPAA_MPI_ERR_IO
    integer, parameter :: MPI_ERR_KEYVAL = VAPAA_MPI_ERR_KEYVAL
    integer, parameter :: MPI_ERR_LOCKTYPE = VAPAA_MPI_ERR_LOCKTYPE
    integer, parameter :: MPI_ERR_NAME = VAPAA_MPI_ERR_NAME
    integer, parameter :: MPI_ERR_NO_MEM = VAPAA_MPI_ERR_NO_MEM
    integer, parameter :: MPI_ERR_NOT_SAME = VAPAA_MPI_ERR_NOT_SAME
    integer, parameter :: MPI_ERR_NO_SPACE = VAPAA_MPI_ERR_NO_SPACE
    integer, parameter :: MPI_ERR_NO_SUCH_FILE = VAPAA_MPI_ERR_NO_SUCH_FILE
    integer, parameter :: MPI_ERR_PORT = VAPAA_MPI_ERR_PORT
    integer, parameter :: MPI_ERR_QUOTA = VAPAA_MPI_ERR_QUOTA
    integer, parameter :: MPI_ERR_READ_ONLY = VAPAA_MPI_ERR_READ_ONLY
    integer, parameter :: MPI_ERR_RMA_ATTACH = VAPAA_MPI_ERR_RMA_ATTACH
    integer, parameter :: MPI_ERR_RMA_CONFLICT = VAPAA_MPI_ERR_RMA_CONFLICT
    integer, parameter :: MPI_ERR_RMA_RANGE = VAPAA_MPI_ERR_RMA_RANGE
    integer, parameter :: MPI_ERR_RMA_SHARED = VAPAA_MPI_ERR_RMA_SHARED
    integer, parameter :: MPI_ERR_RMA_SYNC = VAPAA_MPI_ERR_RMA_SYNC
    integer, parameter :: MPI_ERR_SERVICE = VAPAA_MPI_ERR_SERVICE
    integer, parameter :: MPI_ERR_SIZE = VAPAA_MPI_ERR_SIZE
    integer, parameter :: MPI_ERR_SPAWN = VAPAA_MPI_ERR_SPAWN
    integer, parameter :: MPI_ERR_UNSUPPORTED_DATAREP = VAPAA_MPI_ERR_UNSUPPORTED_DATAREP
    integer, parameter :: MPI_ERR_UNSUPPORTED_OPERATION = VAPAA_MPI_ERR_UNSUPPORTED_OPERATION
    integer, parameter :: MPI_ERR_WIN = VAPAA_MPI_ERR_WIN
    integer, parameter :: MPI_ERR_RMA_FLAVOR = VAPAA_MPI_ERR_RMA_FLAVOR
    integer, parameter :: MPI_ERR_PROC_ABORTED = VAPAA_MPI_ERR_PROC_ABORTED
    integer, parameter :: MPI_ERR_VALUE_TOO_LARGE = VAPAA_MPI_ERR_VALUE_TOO_LARGE
    integer, parameter :: MPI_ERR_SESSION = VAPAA_MPI_ERR_SESSION
    integer, parameter :: MPI_ERR_ERRHANDLER = VAPAA_MPI_ERR_ERRHANDLER
    integer, parameter :: MPI_ERR_ABI = VAPAA_MPI_ERR_ABI
    integer, parameter :: MPI_ERR_LASTCODE = VAPAA_MPI_ERR_LASTCODE

    integer :: MPI_BOTTOM = 0
    integer :: MPI_IN_PLACE = 1
    integer :: MPI_ARGV_NULL = 0
    integer :: MPI_ARGVS_NULL = 0
    integer :: MPI_ERRCODES_IGNORE = 0
    integer :: MPI_UNWEIGHTED = 10
    integer :: MPI_WEIGHTS_EMPTY = 11
    integer :: MPI_STATUS_IGNORE(MPI_STATUS_SIZE) = 0
    integer :: MPI_STATUSES_IGNORE(MPI_STATUS_SIZE,1) = 0

end module mpi_f90_constants
