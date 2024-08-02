#!/bin/bash

cd 000_eq
rm -f 000.2_eq_ligandOnly.log
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p1 000.2_eq_ligandOnly.conf > 000.2_eq_ligandOnly.log
date +"%D %T" > 000.2_eq_ligandOnly.start.time



python 000.3_updateCenters.py



cd ../003_MoleculeUnbound/
rm -f *.log
date +"%D %T" > 003.1_fep_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p16 003.1_fep_backward.conf > 003.1_fep_backward.log &
pids[1]=$!

cd ../004_RestraintUnbound/
rm -f *.log
date +"%D %T" > 004.1_ti_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p16 004.1_ti_backward.conf > 004.1_ti_backward.log &
pids[2]=$!

for pid in ${pids[*]}; do
    wait $pid
done


cd ../003_MoleculeUnbound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p16 003.2_fep_forward.conf > 003.2_fep_forward.log &
date +"%D %T" > 003.2_fep_forward.start.time

cd ../004_RestraintUnbound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p16 004.2_ti_forward.conf  > 004.2_ti_forward.log &
date +"%D %T" > 004.2_ti_forward.start.time
