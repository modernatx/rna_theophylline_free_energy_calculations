#!/bin/bash

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be fixed
dir_list="6-xanthine" #"2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="4-55NaCl_3Mg_bb_colvar" #"4-55NaCl_3Mg_bb_colvar 2-Neut_3Mg 3-55KCl_3Mg"
rep_list="4-rep4"
WD=$PWD

## set common directory path
#cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
#cmn_dir="/home/misik/repos/3_mg_rna_small_molecule_fe/common_files"
cmn_dir="/home/misik/repos/rna_theophylline_free_energy_calculations/fe_calcs_with_3_mg/common_files"

## make sure bfee environment is properly setup before running this script
# conda activate bfee
cd $WD
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE
            ## copy python file from common_files
            cp ${cmn_dir}/run_1_BFEE_MI.sh .
            cd ../../../
        done
        cd ../../
    done
    cd ..
done
