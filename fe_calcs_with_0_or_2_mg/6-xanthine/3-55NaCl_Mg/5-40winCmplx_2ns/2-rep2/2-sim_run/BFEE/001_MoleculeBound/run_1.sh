#!/bin/bash

date +"%D %T" > 001.1_fep_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p12 001.1_fep_backward.conf > 001.1_fep_backward.log &
wait

date +"%D %T" > 001.2_fep_forward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p12 001.2_fep_forward.conf > 001.2_fep_forward.log &
