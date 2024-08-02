#!/bin/bash

cd 001_MoleculeBound
date +"%D %T" > 001.1_fep_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p8 001.1_fep_backward.conf > 001.1_fep_backward.log &

cd ../002_RestraintBound/
date +"%D %T" > 002.1_ti_backward.start.time
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p8 002.1_ti_backward.conf > 002.1_ti_backward.log &

