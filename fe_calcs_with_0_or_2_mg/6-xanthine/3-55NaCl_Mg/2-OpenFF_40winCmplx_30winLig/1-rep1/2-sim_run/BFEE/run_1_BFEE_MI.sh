#!/bin/bash

cd 000_eq
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p1 000.2_eq_ligandOnly.conf > 000.2_eq_ligandOnly.log &
date +"%D %T" > 000.2_eq_ligandOnly.start.time

date +"%D %T" > 000.1_eq.start.time
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p1 000.1_eq.conf > 000.1_eq.log

python 000.3_updateCenters.py

cd ../001_MoleculeBound
date +"%D %T" > 001.1_fep_backward.start.time
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p12 001.1_fep_backward.conf > 001.1_fep_backward.log &
pids[1]=$!

cd ../002_RestraintBound/
date +"%D %T" > 002.1_ti_backward.start.time
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p12 002.1_ti_backward.conf > 002.1_ti_backward.log &
pids[2]=$!

cd ../003_MoleculeUnbound/
date +"%D %T" > 003.1_fep_backward.start.time
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 003.1_fep_backward.conf > 003.1_fep_backward.log &
pids[3]=$!

cd ../004_RestraintUnbound/
date +"%D %T" > 004.1_ti_backward.start.time
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 004.1_ti_backward.conf > 004.1_ti_backward.log &
pids[4]=$!

for pid in ${pids[*]}; do
    wait $pid
done

cd ../001_MoleculeBound
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p12 001.2_fep_forward.conf > 001.2_fep_forward.log &
date +"%D %T" >  001.2_fep_forward.start.time

cd ../002_RestraintBound/
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p12 002.2_ti_forward.conf > 002.2_ti_forward.log &
date +"%D %T" > 002.2_ti_forward.start.time

cd ../003_MoleculeUnbound/
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 003.2_fep_forward.conf > 003.2_fep_forward.log &
date +"%D %T" > 003.2_fep_forward.start.time

cd ../004_RestraintUnbound/
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 004.2_ti_forward.conf  > 004.2_ti_forward.log &
date +"%D %T" > 004.2_ti_forward.start.time