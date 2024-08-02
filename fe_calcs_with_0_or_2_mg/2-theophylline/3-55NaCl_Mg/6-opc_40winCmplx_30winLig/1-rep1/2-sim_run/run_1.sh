#!/bin/bash
cd equ_0
date +"%D %T" > min.0.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 min.0.conf > min.0_g5_32.log &
wait
date +"%D %T" > equ.0.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 equ.0.conf > equ.0_g5_32.log &
wait

cd ../equ_1
date +"%D %T" > equ.0.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 equ.0.conf > equ.0.log &
wait
date +"%D %T" > equ.1.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 equ.1.conf > equ.1.log &
wait
date +"%D %T" > equ.2.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 equ.2.conf > equ.2.log &
wait
date +"%D %T" > equ.3.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 equ.3.conf > equ.3.log &
wait
date +"%D %T" > equ.4.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 equ.4.conf > equ.4.log &
wait
cd ../equ_2
date +"%D %T" > equ.0.start.time
/home/arasouli/opt/NAMD_2.14_Linux-x86_64-multicore-CUDA/namd2 +p16 equ.0.conf > equ.0.log &
wait
