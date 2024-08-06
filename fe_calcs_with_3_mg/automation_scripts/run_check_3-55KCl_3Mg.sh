#!/bin/bash

#####################################################################
## Add the necessary lines to the colvar files of step 000, 0001,
## and 002 of BFEE, to restrain the backbone RMSD of the RNA and 
## calculate its contribution to the free energy.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="3-55KCl_3Mg" # "2-Neut_3Mg"
rep_list="1-rep1 2-rep2 3-rep3"
step_list="000 001 002 003 004"

#cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_3_mg/common_files"

WD=$PWD



## loop over the compounds, conditions and replicas
## and copy files over
for val4 in $step_list; do
    echo "--------------------------------------------------------------"
    echo "BFEE STEP:" ${val4}
    echo "--------------------------------------------------------------"
    for val1 in $dir_list; do
        cd ${val1}
        for val2 in $cond_list; do
            cd ${val2}/1-40winCmplx_30winLig/
            echo ${val1},${val2}$'\n'
            for val3 in $rep_list; do
                cd ${val3}/
                echo ${val3}$'\n'
                        
                cd 2-sim_run/BFEE
                
                # To check all steps finished
                #tail */*log -n 2
                # To check individual BFEE2 steps
                tail ${val4}*/*log -n 2 
                echo $'\n'
                
                cd ../../..
            done
            cd ../../
        done
        cd ..
    done
done
