#!/bin/bash
cd equ_2
date +"%D %T" > equ.1.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p32 equ.1.conf > equ.1.log &
wait
