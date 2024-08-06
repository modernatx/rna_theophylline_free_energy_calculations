#!/bin/bash

#####################################################################
## This script run the first step 000_eq for all on one instance
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
# cond_list="8-5NaCl_Mg_bb_colvar 9-5NaCl_bb_colvar"
cond_list="9-5NaCl_bb_colvar"
rep_list="1-rep1 2-rep2 3-rep3"

#cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_0_or_2_mg/common_files"

WD=$PWD



## loop over the compounds, conditions and replicas
## and genrate xyz and ndx files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/2-40winCmplx_30winLig_pdb_ref
        for val3 in $rep_list; do
        
            cd ${val3}/2-sim_run/BFEE/000_eq
            rm -f 000.1_eq.log
            date +"%D %T" > 000.1_eq.start.time
            /home/arasouli/opt/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA/namd3 +p1 000.1_eq.conf > 000.1_eq.log &
            
            cd ../../../..
        done
        cd ../../
    done
    cd ..
done
