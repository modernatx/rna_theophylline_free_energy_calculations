#!/bin/bash

cd 003_MoleculeUnbound/
rm -f *.log
date +"%D %T" > 003.1_fep_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p32 003.1_fep_backward.conf > 003.1_fep_backward.log


date +"%D %T" > 003.2_fep_forward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p32 003.2_fep_forward.conf > 003.2_fep_forward.log

