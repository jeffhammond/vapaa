include ../../make.inc

SUBDIRS = attr coll comm datatype ext info init io misc profile pt2pt rma spawn subarray timer topo

AR := ar
ARFLAGS := -r

# obviously, you have to compile in ../source first
FCFLAGS += -I../../source -L../../source -lmpi_f08

FCFLAGS += -Wno-unused-variable -Wno-unused-dummy-argument

all: $(patsubst %.f90,%.x,$(wildcard *.f90))

%.x: %.o ../source/libmpi_f08.a
	$(FC) $(FCFLAGS) $^ $(MPI_LIBS) -o $@

%.o: %.f90
	$(FC) $(FCFLAGS) -c $<

clean:
	-rm -fr *.dSYM
	-rm -f *.x *.o
