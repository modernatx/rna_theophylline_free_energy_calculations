#!/bin/bash

# This script places the missing 000.3_updateCenters.py in BFEE2 subdirectory
# and deletes the log and ouput files of the failed BFEE2 runs

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be fixed
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="4-55NaCl_3Mg_bb_colvar" 
rep_list="1-rep1 2-rep2 3-rep3"
WD=$PWD

## set common directory path
#cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"
cmn_dir="/home/misik/repos/3_mg_rna_small_molecule_fe/common_files"

cd $WD

for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE/000_eq
            ## copy python file from common_files
            cp ${cmn_dir}/000.3_updateCenters.py .
            rm *.log
            rm -rf output
            mkdir output
            cd ../../../../
        done
        cd ../../
    done
    cd ..
done