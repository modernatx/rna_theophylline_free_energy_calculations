#!/bin/bash

#####################################################################
## This script neutralizes the ligOnly system. Since RNA-ligand    ##
## system is neutral, then when RNA is removed to make the ligOnly ##
## system, the overall charge of ligOnly is non-zero. After        ##
## neutralization, 'ligandOnly.xyz' and 'fep_ligandOnly.pdb' are   ##
## regenerated.                                                    ##
#####################################################################




## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be fixed
# dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
dir_list="5-hypoxanthine"
cond_list="9-5NaCl_bb_colvar"
# rep_list="1-rep1 2-rep2 3-rep3"
rep_list=" 1-rep1 3-rep3"
WD=$PWD
## set common directory path
cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"

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
            cp ${cmn_dir}/gen_xyz_ligOnly.py .
            ## generate the files
            python gen_xyz_ligOnly.py
            cd ../../../
        done
        cd ../../
    done
    cd ..
done
