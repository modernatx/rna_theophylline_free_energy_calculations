#!/bin/bash

cd 000_eq
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p1 000.2_eq_ligandOnly.conf > 000.2_eq_ligandOnly.log &
date +"%D %T" > 000.2_eq_ligandOnly.start.time

date +"%D %T" > 000.1_eq.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p1 000.1_eq.conf > 000.1_eq.log

python 000.3_updateCenters.py

cd ../001_MoleculeBound
date +"%D %T" > 001.1_fep_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p3 001.1_fep_backward.conf > 001.1_fep_backward.log &

cd ../002_RestraintBound/
date +"%D %T" > 002.1_ti_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p3 002.1_ti_backward.conf > 002.1_ti_backward.log &

cd ../003_MoleculeUnbound/
date +"%D %T" > 003.1_fep_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p1 003.1_fep_backward.conf > 003.1_fep_backward.log &

cd ../004_RestraintUnbound/
date +"%D %T" > 004.1_ti_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p1 004.1_ti_backward.conf > 004.1_ti_backward.log &
