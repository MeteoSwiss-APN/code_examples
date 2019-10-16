F90=pgfortran
FFLAGS = -g -traceback -O -Mpreprocess -Mrecursive -Mallocatable=03 -acc=verystrict -ta=nvidia:cc60,cuda10.0 -Minfo=all -Mcuda
LDFLAGS = -ta=nvidia:cc60,cuda10.0 -Mcuda -Mnorpath

OBJ = main.o types.o

all: clean compile run

compile: $(OBJ)
	$(F90) $(LDFLAGS) -o typetest $^

%.o: %.f90
	$(F90) $(FFLAGS) -c $^

main.o: main.f90 types.o

types.o: types.f90

run:
	nsys profile -f true -o typetest ./typetest 2> log.txt

clean:
	rm -f *.o *.mod *.qdstrm *.qdrep *.log
