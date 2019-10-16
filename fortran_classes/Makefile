F90=pgfortran
FFLAGS = -g -traceback -O -Mpreprocess -Mrecursive -Mallocatable=03 -acc=verystrict -ta=nvidia:cc60,cuda10.0 -Minfo=all -Mcuda
LDFLAGS = -ta=nvidia:cc60,cuda10.0 -Mcuda -Mnorpath

OBJ = main.o classes.o

all: clean compile run

compile: $(OBJ)
	$(F90) $(LDFLAGS) -o classtest $^

%.o: %.f90
	$(F90) $(FFLAGS) -c $^

main.o: main.f90 classes.o

classes.o: classes.f90

run:
	nsys profile -f true -o classtest ./classtest 2> log.txt

clean:
	rm -f *.o *.mod *.log *.qdstrm *.qdrep
