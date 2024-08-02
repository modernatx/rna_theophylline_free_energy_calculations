#!/bin/bash

# cd 000_eq
# /home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p12 000.2_eq_ligandOnly.conf > 000.2_eq_ligandOnly.log &
# date +"%D %T" > 000.2_eq_ligandOnly.start.time

# date +"%D %T" > 000.1_eq.start.time
# /home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p12 000.1_eq.conf > 000.1_eq.log

# python 000.3_updateCenters.py

# cd ../001_MoleculeBound

cd 003_MoleculeUnbound/
rm -f 003.2_fep_forward.log
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore/namd2 +p20 003.2_fep_forward.conf > 003.2_fep_forward.log &
date +"%D %T" > 003.2_fep_forward.start.time

