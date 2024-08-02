#!/bin/bash

cd 000_eq
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 000.2_eq_ligandOnly.conf > 000.2_eq_ligandOnly.log &
date +"%D %T" > 000.2_eq_ligandOnly.start.time

date +"%D %T" > 000.1_eq.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 000.1_eq.conf > 000.1_eq.log

python 000.3_updateCenters.py


cd ../002_RestraintBound/
date +"%D %T" > 002.1_ti_backward.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p24 002.1_ti_backward.conf > 002.1_ti_backward.log &
pids[1]=$!


cd ../004_RestraintUnbound/
date +"%D %T" > 004.1_ti_backward.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p8 004.1_ti_backward.conf > 004.1_ti_backward.log &
pids[2]=$!

for pid in ${pids[*]}; do
    wait $pid
done




cd ../002_RestraintBound/
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p24 002.2_ti_forward.conf > 002.2_ti_forward.log &
date +"%D %T" > 002.2_ti_forward.start.time
pids[1]=$!


cd ../004_RestraintUnbound/
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p8 004.2_ti_forward.conf  > 004.2_ti_forward.log &
date +"%D %T" > 004.2_ti_forward.start.time
pids[2]=$!

for pid in ${pids[*]}; do
    wait $pid
done



cd ../001_MoleculeBound
date +"%D %T" > 001.1_fep_backward.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore/namd2 +p18 001.1_fep_backward.conf > 001.1_fep_backward.log &
pids[1]=$!


cd ../003_MoleculeUnbound/
date +"%D %T" > 003.1_fep_backward.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore/namd2 +p14 003.1_fep_backward.conf > 003.1_fep_backward.log &
pids[2]=$!

for pid in ${pids[*]}; do
    wait $pid
done

cd ../001_MoleculeBound
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore/namd2 +p18 001.2_fep_forward.conf > 001.2_fep_forward.log & 
date +"%D %T" >  001.2_fep_forward.start.time

cd ../003_MoleculeUnbound/
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore/namd2 +p14 003.2_fep_forward.conf > 003.2_fep_forward.log &
date +"%D %T" > 003.2_fep_forward.start.time