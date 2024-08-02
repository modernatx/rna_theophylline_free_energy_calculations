#!/bin/bash
cd 001_MoleculeBound
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 001.2_fep_forward.conf > 001.2_fep_forward.log & 
date +"%D %T" >  001.2_fep_forward.start.time

cd ../002_RestraintBound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 002.2_ti_forward.conf > 002.2_ti_forward.log &
date +"%D %T" > 002.2_ti_forward.start.time

cd ../003_MoleculeUnbound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 003.2_fep_forward.conf > 003.2_fep_forward.log &
date +"%D %T" > 003.2_fep_forward.start.time

cd ../004_RestraintUnbound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p2 004.2_ti_forward.conf  > 004.2_ti_forward.log &
date +"%D %T" > 004.2_ti_forward.start.time
