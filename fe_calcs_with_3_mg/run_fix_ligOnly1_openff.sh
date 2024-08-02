#!/bin/bash

#####################################################################
## This script neutralizes the ligOnly system. Since RNA-ligand    ##
## system is neutral, then when RNA is removed to make the ligOnly ##
## system, the overall charge of ligOnly is non-zero. After        ##
## neutralization, 'ligandOnly.xyz' and 'fep_ligandOnly.pdb' are   ##
## regenerated.                                                    ##
#####################################################################



## make sure ambertools environment is properly setup before running this script
## you can activate the ambertools even before running this script to make sure you 
## have the right env
# conda activate ambertools

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be fixed
dir_list="3-1_methylxanthine"
# dir_list="7-caffeine"
cond_list="1-55NaCl_3Mg"
rep_list="2-rep2"
WD=$PWD
## set common directory path
cmn_dir="/home/arasouli/repos/alchemical/3_mg_rna_small_molecule_FE/common_files"

## loop over the compounds, conditions and replicas
## and fix the reionize
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/2-OpenFF_40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/2-sim_run/BFEE
            cp ${cmn_dir}/run_1_BFEE.sh run_1.sh
            cp ${cmn_dir}/strip.py .

            python strip.py
            cp ${cmn_dir}/fix_openff_pdb_BFEE_ligOnly.tcl .
            vmd -dispdev text -e fix_openff_pdb_BFEE_ligOnly.tcl
            cd ../../../
        done
        cd ../../
    done
    cd ..
done


