### Usage Instructions

## Prepare environment:
```
module load daint-gpu
module switch PrgEnv-cray/6.0.9 PrgEnv-pgi
module load cudatoolkit
```


## To Compile:
```
ftn -ta=nvidia:cc60 -Minfo=accel -c routine.f90
ftn -ta=nvidia:cc60 -Minfo=accel routine.o test_routine_main.f90
```

## To run:
```
srun --account d56 --partition debug -C gpu -n1 a.out 1000
```
OR
```
sbatch test.run
```
