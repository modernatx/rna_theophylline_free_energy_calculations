#!/bin/bash
#while [ -d /proc/7074 ]
#do
#        sleep 1m
#done

#while [ -d /proc/37076 ]
#do
#        sleep 1m
#done

cd 001_MoleculeBound
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p8 001.2_fep_forward.conf > 001.2_fep_forward.log & 
date +"%D %T" >  001.2_fep_forward.start.time

cd ../002_RestraintBound/
/home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p8 002.2_ti_forward.conf > 002.2_ti_forward.log &
date +"%D %T" > 002.2_ti_forward.start.time

