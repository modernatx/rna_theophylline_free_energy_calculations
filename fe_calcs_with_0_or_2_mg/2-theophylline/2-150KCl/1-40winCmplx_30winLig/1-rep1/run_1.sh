#!/bin/bash
cd 000_eq
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 000.1_eq.conf > 000.1_eq.log
date +"%D %T" >  000.1_eq.start.time

/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 000.2_eq_ligandOnly.conf > 000.2_eq_ligandOnly.log 
date +"%D %T" >  000.2_eq_ligandOnly.start.time

python 000.3_updateCenters.py


cd ../001_MoleculeBound
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 001.1_fep_backward.conf > 001.1_fep_backward.log & 
date +"%D %T" >  001.1_fep_backward.start.time

cd ../002_RestraintBound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 002.1_ti_backward.conf > 002.1_ti_backward.log &
date +"%D %T" > 002.1_ti_backward.start.time

cd ../003_MoleculeUnbound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 003.1_fep_backward.conf > 003.1_fep_backward.log &
date +"%D %T" > 003.1_fep_backward.start.time

cd ../004_RestraintUnbound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 004.1_ti_backward.conf  > 004.1_ti_backward.log &
date +"%D %T" > 004.1_ti_backward.start.time
