#ifndef __cplusplus
#error Sorry, but you have to use a C++ compiler.
#endif
#if defined(__cplusplus) && (__cplusplus < 201703L)
#error Sorry, but you have to use a C++17 compiler.
#endif

#include <cstdio>
#include <cstdlib>
#include <cstdint>

#include <string>
#include <utility>
#include <map>
#include <mutex>

extern "C" {

// we do not want anything MPI C++ related here.
// this header is only used to determine the MPI ABI we are compiling against,
// and then only the scalar types (impl-scalar-types.h) it seems.
#define OMPI_SKIP_MPICXX
#define MPICH_SKIP_MPICXX
#include <mpi.h>

}

std::map<int,MPI_Op> op_f2c_map{};
//std::map<int,MPI_Datatype> type_f2c_map{};

std::mutex op_f2c_mutex;
//std::mutex type_f2c_mutex;

extern "C" {

int add_op_f2c(int op_f, MPI_Op op_c)
{
    const std::lock_guard<std::mutex> lock(op_f2c_mutex);
#if DEBUG
    printf("%s: insert_or_assign(op_f=%d op_c=%lx\n",
            __func__, op_f, (intptr_t)op_c);
#endif
    // insert_or_assign (C++17) inserts an element or assigns to the current element if the key already exists
    auto [it,rc] = op_f2c_map.insert_or_assign(op_f, op_c);
#if DEBUG
    printf("%s: insert_or_assign(op_f=%d op_c=%lx) returned %d\n",
            __func__, op_f, (intptr_t)op_c, rc);
#endif
    return 1; // SUCCESS int{rc};
    (void)it;
    (void)rc;
}

int find_op_f2c(int op_f, MPI_Op * op_c)
{
    const std::lock_guard<std::mutex> lock(op_f2c_mutex);
    try {
        auto op = op_f2c_map.at(op_f);
#if DEBUG
        printf("%s: lookup(op_f=%d) -> %lx\n",
                __func__, op_f, (intptr_t)op_c);
#endif
        *op_c = op;
        return 1;
    }
    catch (...) {
        printf("%s: lookup(op_f=%d) failed\n", __func__, op_f);
        return 0;
    }
}

int remove_op_f2c(int op_f)
{
    const std::lock_guard<std::mutex> lock(op_f2c_mutex);
    // returns the number of elements removed, so 0=failure and 1=success
    return op_f2c_map.erase(op_f);
}

}

