### Usage Instructions

This example was created to test whether you can pass a paramater to a function, for example the index of a loop, and use this within async, ie async(i), to enable concurrent streams to run some indepenedent code blocks. The run script also runs run the nsys profiler, which you can then open with nsight systems. THen you can see that the different async streams are used to run the code almost in parallel (with delay from sequential cuda api calls). 


## Prepare environment (daint):
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
