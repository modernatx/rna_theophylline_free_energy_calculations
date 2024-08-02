#!/bin/bash
cd equ_0
time { /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 min.0.conf > min.0.log & } 2> min.0.time
wait
time { /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 equ.0.conf > equ.0.log & } 2> equ.0.time
wait
cd ../equ_1
time { /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 equ.0.conf > equ.0.log & } 2> equ.0.time
wait
time { /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 equ.1.conf > equ.1.log & } 2> equ.1.time
wait
time { /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 equ.2.conf > equ.2.log & } 2> equ.2.time
wait
time { /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 equ.3.conf > equ.3.log & } 2> equ.3.time
wait
time { /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 equ.4.conf > equ.4.log & } 2> equ.4.time
wait
cd ../equ_2
time { /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p4 equ.0.conf > equ.0.log & } 2> equ.0.time
wait
