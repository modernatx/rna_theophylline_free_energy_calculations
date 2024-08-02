#!/bin/bash
cd equ_0
date +"%D %T" > min.0.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p32 min.0.conf > min.0_g5_32.log &
wait
date +"%D %T" > equ.0.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p32 equ.0.conf > equ.0_g5_32.log &
wait
