! SPDX-License-Identifier: MIT

#include "vapaa_constants.h"

module mpi_global_constants
    use iso_c_binding, only: c_int, c_int64_t, c_intptr_t
    use mpi_handle_types

    ! thread levels
    integer, parameter :: MPI_THREAD_SINGLE     = VAPAA_MPI_THREAD_SINGLE
    integer, parameter :: MPI_THREAD_FUNNELED   = VAPAA_MPI_THREAD_FUNNELED
    integer, parameter :: MPI_THREAD_SERIALIZED = VAPAA_MPI_THREAD_SERIALIZED
    integer, parameter :: MPI_THREAD_MULTIPLE   = VAPAA_MPI_THREAD_MULTIPLE
                                                                           
    ! comparisons (communicators and groups)
    integer, parameter :: MPI_IDENT     = VAPAA_MPI_IDENT
    integer, parameter :: MPI_CONGRUENT = VAPAA_MPI_CONGRUENT
    integer, parameter :: MPI_SIMILAR   = VAPAA_MPI_SIMILAR
    integer, parameter :: MPI_UNEQUAL   = VAPAA_MPI_UNEQUAL

    ! topology types
    integer, parameter :: MPI_CART       = VAPAA_MPI_CART
    integer, parameter :: MPI_GRAPH      = VAPAA_MPI_GRAPH
    integer, parameter :: MPI_DIST_GRAPH = VAPAA_MPI_DIST_GRAPH

    ! TODO: These now work as initializers, but they need to be handled
    !       everywhere they can be used.  That will be tedious...

    ! useful handles
    type(MPI_Comm), parameter     :: MPI_COMM_WORLD    = MPI_Comm(MPI_VAL     = VAPAA_MPI_COMM_WORLD   )
    type(MPI_Comm), parameter     :: MPI_COMM_SELF     = MPI_Comm(MPI_VAL     = VAPAA_MPI_COMM_SELF    )

    ! NULL handles
    type(MPI_Comm), parameter     :: MPI_COMM_NULL     = MPI_Comm(MPI_VAL     = VAPAA_MPI_COMM_NULL    )
    type(MPI_Datatype), parameter :: MPI_DATATYPE_NULL = MPI_Datatype(MPI_VAL = VAPAA_MPI_DATATYPE_NULL)
    type(MPI_Errhandler), parameter :: MPI_ERRHANDLER_NULL = MPI_Errhandler(MPI_VAL = VAPAA_MPI_ERRHANDLER_NULL)
    type(MPI_File), parameter     :: MPI_FILE_NULL     = MPI_File(MPI_VAL     = VAPAA_MPI_FILE_NULL    )
    type(MPI_Group), parameter    :: MPI_GROUP_NULL    = MPI_Group(MPI_VAL    = VAPAA_MPI_GROUP_NULL   )
    type(MPI_Group), parameter    :: MPI_GROUP_EMPTY   = MPI_Group(MPI_VAL    = VAPAA_MPI_GROUP_EMPTY  )
    type(MPI_Info), parameter     :: MPI_INFO_NULL     = MPI_Info(MPI_VAL     = VAPAA_MPI_INFO_NULL    )
    type(MPI_Info), parameter     :: MPI_INFO_ENV      = MPI_Info(MPI_VAL     = VAPAA_MPI_INFO_ENV     )
    type(MPI_Message), parameter  :: MPI_MESSAGE_NULL  = MPI_Message(MPI_VAL  = VAPAA_MPI_MESSAGE_NULL )
    type(MPI_Op), parameter       :: MPI_OP_NULL       = MPI_Op(MPI_VAL       = VAPAA_MPI_OP_NULL      )
    type(MPI_Request), parameter  :: MPI_REQUEST_NULL  = MPI_Request(MPI_VAL  = VAPAA_MPI_REQUEST_NULL )
    type(MPI_Session), parameter  :: MPI_SESSION_NULL  = MPI_Session(MPI_VAL  = VAPAA_MPI_SESSION_NULL )
    type(MPI_Win), parameter      :: MPI_WIN_NULL      = MPI_Win(MPI_VAL      = VAPAA_MPI_WIN_NULL     )

    type(MPI_Errhandler), parameter :: MPI_ERRORS_ARE_FATAL = MPI_Errhandler(MPI_VAL = VAPAA_MPI_ERRORS_ARE_FATAL)
    type(MPI_Errhandler), parameter :: MPI_ERRORS_ABORT     = MPI_Errhandler(MPI_VAL = VAPAA_MPI_ERRORS_ABORT)
    type(MPI_Errhandler), parameter :: MPI_ERRORS_RETURN    = MPI_Errhandler(MPI_VAL = VAPAA_MPI_ERRORS_RETURN)

    ! Magic sentinels
    ! The constants that cannot be used in initialization expressions or assignments in Fortran are as follows:
    ! Buffer address sentinels - the values do not matter, as they are detected by address.
    integer :: MPI_BOTTOM          =  0
    integer :: MPI_IN_PLACE        =  1
    integer :: MPI_ARGV_NULL       =  0
    integer :: MPI_ARGVS_NULL      =  0
    integer :: MPI_ERRCODES_IGNORE =  0
    integer :: MPI_UNWEIGHTED      = 10
    integer :: MPI_WEIGHTS_EMPTY   = 11
    ! Note that in Fortran MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE are objects like MPI_BOTTOM
    ! (not usable for initialization or assignment).
    ! MPI_STATUS_IGNORE and MPI_STATUSES_IGNORE are not required to have the same values in C and Fortran.
    type(MPI_Status) :: MPI_STATUS_IGNORE
    type(MPI_Status) :: MPI_STATUSES_IGNORE(1)

    integer, parameter :: MPI_PROC_NULL  = VAPAA_MPI_PROC_NULL
    integer, parameter :: MPI_ROOT       = VAPAA_MPI_ROOT
    type(MPI_Message), parameter  :: MPI_MESSAGE_NO_PROC = MPI_Message(MPI_VAL  = VAPAA_MPI_MESSAGE_NO_PROC)

    integer, parameter :: MPI_ANY_SOURCE = VAPAA_MPI_ANY_SOURCE
    integer, parameter :: MPI_ANY_TAG    = VAPAA_MPI_ANY_TAG

    ! index sentinel in waitany etc.
    integer, parameter :: MPI_UNDEFINED       = VAPAA_MPI_UNDEFINED

    ! 9.1.2 environmental query attributes
    integer, parameter :: MPI_TAG_UB          = VAPAA_MPI_TAG_UB
    integer, parameter :: MPI_IO              = VAPAA_MPI_IO
    integer, parameter :: MPI_HOST            = VAPAA_MPI_HOST
    integer, parameter :: MPI_WTIME_IS_GLOBAL = VAPAA_MPI_WTIME_IS_GLOBAL
    integer, parameter :: MPI_APPNUM          = VAPAA_MPI_APPNUM
    integer, parameter :: MPI_LASTUSEDCODE    = VAPAA_MPI_LASTUSEDCODE
    integer, parameter :: MPI_UNIVERSE_SIZE   = VAPAA_MPI_UNIVERSE_SIZE

    integer, parameter :: MPI_WIN_BASE          = VAPAA_MPI_WIN_BASE
    integer, parameter :: MPI_WIN_DISP_UNIT     = VAPAA_MPI_WIN_DISP_UNIT
    integer, parameter :: MPI_WIN_SIZE          = VAPAA_MPI_WIN_SIZE
    integer, parameter :: MPI_WIN_CREATE_FLAVOR = VAPAA_MPI_WIN_CREATE_FLAVOR
    integer, parameter :: MPI_WIN_MODEL         = VAPAA_MPI_WIN_MODEL

    ! 2.5.4 Named Constants
    ! The constants that are required to be compile-time constants
    ! (and can thus be used for array length declarations and labels 
    ! in C switch and Fortran case/select statements) are:

    ! 5.1.3 MPI_TYPE_CREATE_SUBARRAY
    integer, parameter :: MPI_ORDER_C       = VAPAA_MPI_ORDER_C
    integer, parameter :: MPI_ORDER_FORTRAN = VAPAA_MPI_ORDER_FORTRAN

    integer, parameter :: MPI_DISTRIBUTE_NONE      = VAPAA_MPI_DISTRIBUTE_NONE
    integer, parameter :: MPI_DISTRIBUTE_BLOCK     = VAPAA_MPI_DISTRIBUTE_BLOCK
    integer, parameter :: MPI_DISTRIBUTE_CYCLIC    = VAPAA_MPI_DISTRIBUTE_CYCLIC
    integer, parameter :: MPI_DISTRIBUTE_DFLT_DARG = VAPAA_MPI_DISTRIBUTE_DFLT_DARG

    integer, parameter :: MPI_COMBINER_NAMED          = VAPAA_MPI_COMBINER_NAMED
    integer, parameter :: MPI_COMBINER_DUP            = VAPAA_MPI_COMBINER_DUP
    integer, parameter :: MPI_COMBINER_CONTIGUOUS     = VAPAA_MPI_COMBINER_CONTIGUOUS
    integer, parameter :: MPI_COMBINER_VECTOR         = VAPAA_MPI_COMBINER_VECTOR
    integer, parameter :: MPI_COMBINER_HVECTOR        = VAPAA_MPI_COMBINER_HVECTOR
    integer, parameter :: MPI_COMBINER_INDEXED        = VAPAA_MPI_COMBINER_INDEXED
    integer, parameter :: MPI_COMBINER_HINDEXED       = VAPAA_MPI_COMBINER_HINDEXED
    integer, parameter :: MPI_COMBINER_INDEXED_BLOCK  = VAPAA_MPI_COMBINER_INDEXED_BLOCK
    integer, parameter :: MPI_COMBINER_HINDEXED_BLOCK = VAPAA_MPI_COMBINER_HINDEXED_BLOCK
    integer, parameter :: MPI_COMBINER_STRUCT         = VAPAA_MPI_COMBINER_STRUCT
    integer, parameter :: MPI_COMBINER_SUBARRAY       = VAPAA_MPI_COMBINER_SUBARRAY
    integer, parameter :: MPI_COMBINER_DARRAY         = VAPAA_MPI_COMBINER_DARRAY
    integer, parameter :: MPI_COMBINER_F90_REAL       = VAPAA_MPI_COMBINER_F90_REAL
    integer, parameter :: MPI_COMBINER_F90_COMPLEX    = VAPAA_MPI_COMBINER_F90_COMPLEX
    integer, parameter :: MPI_COMBINER_F90_INTEGER    = VAPAA_MPI_COMBINER_F90_INTEGER
    integer, parameter :: MPI_COMBINER_RESIZED        = VAPAA_MPI_COMBINER_RESIZED
    integer, parameter :: MPI_COMBINER_VALUE_INDEX    = VAPAA_MPI_COMBINER_VALUE_INDEX

    integer, parameter :: MPIX_TYPECLASS_LOGICAL = VAPAA_MPIX_TYPECLASS_LOGICAL
    integer, parameter :: MPI_TYPECLASS_INTEGER  = VAPAA_MPI_TYPECLASS_INTEGER
    integer, parameter :: MPI_TYPECLASS_REAL     = VAPAA_MPI_TYPECLASS_REAL
    integer, parameter :: MPI_TYPECLASS_COMPLEX  = VAPAA_MPI_TYPECLASS_COMPLEX

    ! 7.4 MPI_COMM_SPLIT_TYPE
    integer, parameter :: MPI_COMM_TYPE_SHARED      = VAPAA_MPI_COMM_TYPE_SHARED
    integer, parameter :: MPI_COMM_TYPE_HW_UNGUIDED = VAPAA_MPI_COMM_TYPE_HW_UNGUIDED
    integer, parameter :: MPI_COMM_TYPE_HW_GUIDED   = VAPAA_MPI_COMM_TYPE_HW_GUIDED
    integer, parameter :: MPI_COMM_TYPE_RESOURCE_GUIDED = VAPAA_MPI_COMM_TYPE_RESOURCE_GUIDED

    integer, parameter :: MPI_MAX_PROCESSOR_NAME         = VAPAA_MPI_MAX_PROCESSOR_NAME         
    integer, parameter :: MPI_MAX_LIBRARY_VERSION_STRING = VAPAA_MPI_MAX_LIBRARY_VERSION_STRING 
    integer, parameter :: MPI_MAX_ERROR_STRING           = VAPAA_MPI_MAX_ERROR_STRING           
    integer, parameter :: MPI_MAX_DATAREP_STRING         = VAPAA_MPI_MAX_DATAREP_STRING         
    integer, parameter :: MPI_MAX_INFO_KEY               = VAPAA_MPI_MAX_INFO_KEY               
    integer, parameter :: MPI_MAX_INFO_VAL               = VAPAA_MPI_MAX_INFO_VAL               
    integer, parameter :: MPI_MAX_OBJECT_NAME            = VAPAA_MPI_MAX_OBJECT_NAME            
    integer, parameter :: MPI_MAX_PORT_NAME              = VAPAA_MPI_MAX_PORT_NAME              
    integer, parameter :: MPI_MAX_STRINGTAG_LEN          = VAPAA_MPI_MAX_STRINGTAG_LEN
    integer, parameter :: MPI_MAX_PSET_NAME_LEN          = VAPAA_MPI_MAX_PSET_NAME_LEN
    integer, parameter :: MPI_BSEND_OVERHEAD             = VAPAA_MPI_BSEND_OVERHEAD
    integer, parameter :: MPI_KEYVAL_INVALID             = VAPAA_MPI_KEYVAL_INVALID

    integer, parameter :: MPI_VERSION    = 5
    integer, parameter :: MPI_SUBVERSION = 0

    integer, parameter :: MPI_STATUS_SIZE = 8
    integer, parameter :: MPI_SOURCE      = 1
    integer, parameter :: MPI_TAG         = 2
    integer, parameter :: MPI_ERROR       = 3

    integer, parameter :: MPI_ADDRESS_KIND = c_intptr_t
    integer, parameter :: MPI_COUNT_KIND   = c_int64_t
    integer, parameter :: MPI_INTEGER_KIND = c_int
    integer, parameter :: MPI_OFFSET_KIND  = c_int64_t

    integer(kind=MPI_OFFSET_KIND), parameter :: MPI_DISPLACEMENT_CURRENT = VAPAA_MPI_DISPLACEMENT_CURRENT

    ! this requires work...
    logical, parameter :: MPI_SUBARRAYS_SUPPORTED        = .false.
    ! i do not know a compiler that does not satisfy this...
    logical, parameter :: MPI_ASYNC_PROTECTS_NONBLOCKING = .true.

end module mpi_global_constants
