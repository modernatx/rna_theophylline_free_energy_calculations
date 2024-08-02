#!/bin/bash
cd contribution_RMSD_ref_wrap
date +"%D %T" > 002.1_ti_backward.start.time
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p32 002.1_ti_backward.conf > 002.1_ti_backward.log

date +"%D %T" > 002.2_ti_forward.start.time
/home/misik/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p32 002.2_ti_forward.conf > 002.2_ti_forward.log