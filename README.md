# Parallel AES Encryption

Simple implementations of the AES encryption standard, team developed for COSC 3P93 (Parallel Programming).

This repository contains both serial and parallel implementations (each stored within the folder with the corresponding name). Two parallel implementations were developed: one via OpenMP (https://www.openmp.org/) and another via MPI (https://www.open-mpi.org/). All implementations support 128, 192, and 256 bit encryption.

Some execution times for each implementation were recorded and can be found within the 'times' folder. The 'parallel' folder also contains shell scripts to test the execution performance of each parallel implementation.
