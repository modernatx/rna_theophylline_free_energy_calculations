#!/bin/bash

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be fixed
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="3-55NaCl_Mg"
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD

## set common directory path
#cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/alchemical_fe_theophylline/common_files"

cd $WD
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/2-OpenFF_40winCmplx_30winLig/ #/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run
            ## copy python file from common_files
            cp ${cmn_dir}/run_1_eq.sh .
            cd ../../
        done
        cd ../../
    done
    cd ..
done
