F90=pgfortran
FFLAGS = -g -traceback -O -Mpreprocess -Mrecursive -Mallocatable=03 -acc=verystrict -ta=nvidia:cc60,cuda10.0 -Minfo=all -Mcuda
LDFLAGS = -ta=nvidia:cc60,cuda10.0 -Mcuda -Mnorpath

OBJ = main.o my_math.o

all: clean compile run

compile: $(OBJ)
	$(F90) $(LDFLAGS) -o asynctest $^

%.o: %.f90
	$(F90) $(FFLAGS) -c $^

main.o: main.f90 my_math.o

my_math.o: my_math.f90

run:
	nsys profile -f true ./asynctest 2> log.txt

clean:
	rm -f *.o *.mod *.log *.qdstrm *.qdrep
