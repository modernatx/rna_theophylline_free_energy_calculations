#!/bin/bash

#####################################################################
## Add the necessary lines to the colvar files of step 000, 0001,
## and 002 of BFEE, to restrain the backbone RMSD of the RNA and 
## calculate its contribution to the free energy.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list=" 1-55NaCl_3Mg"
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
WD=$PWD



## loop over the compounds, conditions and replicas
## and copy files over
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/2-OpenFF_40winCmplx_30winLig/
        echo ${val1},${val2}
        for val3 in $rep_list; do
            cd ${val3}/
            echo ${val3}
            
            
            cd 2-sim_run/
            cp ${cmn_dir}/run_1_equ.sh run_1.sh
             #tail 002*/*log -n 2  
            cd ../../
        done
        cd ../../
    done
    cd ..
done
