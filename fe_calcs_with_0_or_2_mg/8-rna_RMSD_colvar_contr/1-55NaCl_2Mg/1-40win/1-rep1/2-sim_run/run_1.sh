#!/bin/bash
cd equ_0
date +"%D %T" > min.0.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p32 min.0.conf > min.0.log &
wait
date +"%D %T" > equ.0.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p32 equ.0.conf > equ.0.log &
wait
cd ../equ_1
date +"%D %T" > equ.0.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p32 equ.0.conf > equ.0.log &
