#!/bin/bash

#####################################################################
## This script generates complex.xyz file (as a reference in the colvar)
## and also an index file to specify atoms invloved in the RMSD colvar.
## It also adds the keywords to NAMD conf files for colvars.
#####################################################################

## set the list of compounds (dir_list), conditions (cond_list),
## and replicas (rep_list) that need to be created
dir_list="2-theophylline 3-1_methylxanthine 4-3_methylxanthine 5-hypoxanthine 6-xanthine 7-caffeine"
cond_list="4-55NaCl"
# 6-opc_40winCmplx_30winLig
rep_list="1-rep1 2-rep2 3-rep3"
cmn_dir="/home/arasouli/repos/alchemical/rna_small_molecule_FE/common_files"
WD=$PWD



## loop over the compounds, conditions and replicas
## and genrate xyz and ndx files
for val1 in $dir_list; do
    cd ${val1}
    for val2 in $cond_list; do
        cd ${val2}/1-40winCmplx_30winLig/
        for val3 in $rep_list; do
            cd ${val3}/
            cv_list=$(grep Centers ./2-sim_run/BFEE/001_MoleculeBound/colvars.in | awk '{print $2}')
            echo ${cv_list}
            
            
            cd ../
        done
        cd ../../
    done
    cd ..
done
