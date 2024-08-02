#!/bin/bash

#####################################################################
## Fix box vectors in min.0.conf in  directories of OpenFF simulations with 55 mM NaCl and 2 Mg.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="3-55NaCl_Mg"
rep_list="1-rep1 2-rep2 3-rep3"
#cmn_dir="/home/arasouli/repos/alchemical/alchemical_fe_theophylline/common_files"
cmn_dir="/home/misik/repos/alchemical_fe_theophylline/common_files"

WD=$PWD


# loop over the compounds, conditions and replicas
# and copy files over 
for val1 in $dir_list; do
    echo ${val1}
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/
        cd 2-OpenFF_40winCmplx_30winLig/
        
        for val3 in $rep_list; do
            cd ${val3}/
            echo ${val1},${val2},${val3}
            cd 2-sim_run
	        # Copy min.0.conf files from the other repository to use the updated version (VDW switching on)
	        # Don't forget to update cell basis vectors in minimization conf file (either fix with sed or create a reference file common to all ligand).
            cp $cmn_dir/min.0.conf equ_0/

            # Clean log files from equ_0, equ_1, equ_2
            cd equ_0
            rm *.dcd
            rm *.log
            cd ../

            cd equ_1
            rm *.dcd
            rm *.log
            cd ../

            cd equ_2
            rm *.dcd
            rm *.log
            cd ../

            cd ../../
        done
        cd ../../
    done
    cd ..
done
